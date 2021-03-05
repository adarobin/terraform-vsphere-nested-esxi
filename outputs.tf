output "vsan_cache_disks" {
  value = var.enable_vsan ? compact([for disk in vsphere_virtual_machine.esxi.disk : disk.device_address == "scsi:0:1" ? "naa.${replace(lower(disk.uuid), "-", "")}" : ""]) : []
}

output "vsan_capacity_disks" {
  value = var.enable_vsan ? compact([for disk in vsphere_virtual_machine.esxi.disk : disk.device_address == "scsi:0:2" ? "naa.${replace(lower(disk.uuid), "-", "")}" : ""]) : []
}

output "root_password" {
  value     = random_password.esxi_root_password.result
  sensitive = true
}

output "ssl_thumbprint" {
  # need to add colons to make vCenter accept the thumbprint
  value = join(":", [for x in range(0, 40, 2) : substr(data.tls_certificate.nested_esxi_certificate.certificates.0.sha1_fingerprint, x, 2)])
}