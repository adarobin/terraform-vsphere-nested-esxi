locals {
  split_hostname = split(".", var.hostname)
  short_hostname = local.split_hostname[0]
  domain         = join(".", slice(local.split_hostname, 1, length(local.split_hostname)))
}

resource "random_password" "esxi_root_password" {
  length  = 16
  special = true
}

data "vsphere_ovf_vm_template" "ova" {
  name                 = local.short_hostname
  folder               = var.folder_name
  resource_pool_id     = var.resource_pool_id
  datastore_id         = var.datastore_id
  host_system_id       = var.host_system_id
  local_ovf_path       = var.ova_path
  remote_ovf_url       = var.ova_url
  ovf_network_map      = { "VM Network" = var.network_id }
  ip_protocol          = "IPV4"
  disk_provisioning    = "thin"
  ip_allocation_policy = "STATIC_MANUAL"
}

resource "vsphere_virtual_machine" "esxi" {
  name             = data.vsphere_ovf_vm_template.ova.name
  datacenter_id    = var.datacenter_id
  folder           = data.vsphere_ovf_vm_template.ova.folder
  resource_pool_id = data.vsphere_ovf_vm_template.ova.resource_pool_id
  host_system_id   = data.vsphere_ovf_vm_template.ova.host_system_id
  datastore_id     = data.vsphere_ovf_vm_template.ova.datastore_id

  num_cpus               = var.cpu_count_override > 0 ? var.cpu_count_override : data.vsphere_ovf_vm_template.ova.num_cpus
  num_cores_per_socket   = data.vsphere_ovf_vm_template.ova.num_cores_per_socket
  cpu_hot_add_enabled    = data.vsphere_ovf_vm_template.ova.cpu_hot_add_enabled
  cpu_hot_remove_enabled = data.vsphere_ovf_vm_template.ova.cpu_hot_remove_enabled
  nested_hv_enabled      = data.vsphere_ovf_vm_template.ova.nested_hv_enabled
  memory                 = var.memory_override > 0 ? var.memory_override : data.vsphere_ovf_vm_template.ova.memory
  memory_hot_add_enabled = data.vsphere_ovf_vm_template.ova.memory_hot_add_enabled
  annotation             = data.vsphere_ovf_vm_template.ova.annotation
  guest_id               = data.vsphere_ovf_vm_template.ova.guest_id
  alternate_guest_name   = data.vsphere_ovf_vm_template.ova.alternate_guest_name
  firmware               = data.vsphere_ovf_vm_template.ova.firmware
  scsi_type              = data.vsphere_ovf_vm_template.ova.scsi_type
  scsi_controller_count  = data.vsphere_ovf_vm_template.ova.scsi_controller_count
  sata_controller_count  = data.vsphere_ovf_vm_template.ova.sata_controller_count
  ide_controller_count   = data.vsphere_ovf_vm_template.ova.ide_controller_count
  # swap_placement_policy  = data.vsphere_ovf_vm_template.ova.swap_placement_policy

  enable_disk_uuid    = true
  sync_time_with_host = true
  enable_logging      = true

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 5

  network_interface {
    network_id     = var.network_id
    use_static_mac = var.mac_address == "" ? false : true
    mac_address    = var.mac_address
  }

  network_interface {
    network_id = var.network_id
  }

  cdrom {}

  ovf_deploy {
    local_ovf_path       = data.vsphere_ovf_vm_template.ova.local_ovf_path
    remote_ovf_url       = data.vsphere_ovf_vm_template.ova.remote_ovf_url
    disk_provisioning    = data.vsphere_ovf_vm_template.ova.disk_provisioning
    ip_protocol          = data.vsphere_ovf_vm_template.ova.ip_protocol
    ip_allocation_policy = data.vsphere_ovf_vm_template.ova.ip_allocation_policy
    ovf_network_map      = data.vsphere_ovf_vm_template.ova.ovf_network_map
  }

  vapp {
    properties = {
      "guestinfo.hostname"   = var.hostname
      "guestinfo.ipaddress"  = var.ip_address
      "guestinfo.netmask"    = var.netmask
      "guestinfo.gateway"    = var.gateway
      "guestinfo.dns"        = var.dns
      "guestinfo.domain"     = local.domain
      "guestinfo.ntp"        = var.ntp
      "guestinfo.syslog"     = var.syslog
      "guestinfo.password"   = random_password.esxi_root_password.result
      "guestinfo.ssh"        = title(tostring(var.enable_ssh))
      "guestinfo.createvmfs" = title(tostring(!var.enable_vsan))
      "guestinfo.vlan"       = var.vlan_id
    }
  }

  provisioner "local-exec" {
    //wait for the first boot scripts to settle
    command = "sleep 120"
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = random_password.esxi_root_password.result
      host     = self.default_ip_address
    }

    inline = [
      # explicitly set the hostname as the first boot script doesn't seem to work
      "esxcli system hostname set --fqdn=${var.hostname}",

      # configure DDNS
      "esxcli system settings advanced set -o /Misc/PreferredHostName -s ${var.hostname}",

      # flag disks for vSAN if enable_vsan is true
      var.enable_vsan ? "esxcli vsan storage tag add -d ${compact([for disk in self.disk : disk.device_address == "scsi:0:2" ? "naa.${replace(lower(disk.uuid), "-", "")}" : ""])[0]} -t capacityFlash" : "echo vSAN disabled, not configuring",

      # Latest security guidance is to disable slp if you aren't using it
      # Since this is virtual hardware that is indeed the case
      # https://kb.vmware.com/s/article/76372
      "/etc/init.d/slpd stop",
      "esxcli network firewall ruleset set -r CIMSLP -e 0",
      "chkconfig slpd off",

      # Latest security guidance is to disable cim if you aren't using it
      # Since this is virtual hardware that is indeed the case  
      # https://kb.vmware.com/s/article/1025757
      "esxcli system wbem set --enable false",

      # restart management interface for DDNS to take effect
      "esxcli network ip interface set -e false -i vmk0; esxcli network ip interface set -e true -i vmk0",
    ]
  }

  lifecycle {
    ignore_changes = [
      // it looks like some of the properties get deleted from the VM after it is deployed
      // just ignore them after the initial deployment
      vapp.0.properties,
    ]
  }
}

data "tls_certificate" "nested_esxi_certificate" {
  url          = "https://${var.hostname}"
  verify_chain = false

  depends_on = [
    vsphere_virtual_machine.esxi,
  ]
}
