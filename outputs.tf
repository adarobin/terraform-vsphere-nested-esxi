output "vsan_cache_disks" {
  value       = var.enable_vsan ? compact([for disk in vsphere_virtual_machine.esxi.disk : disk.device_address == "scsi:0:1" ? "naa.${replace(lower(disk.uuid), "-", "")}" : ""]) : []
  description = "A list of available vSAN cache disks."
}

output "vsan_capacity_disks" {
  value       = var.enable_vsan ? compact([for disk in vsphere_virtual_machine.esxi.disk : disk.device_address == "scsi:0:2" ? "naa.${replace(lower(disk.uuid), "-", "")}" : ""]) : []
  description = "A list of available vSAN capacity disks."
}

output "root_password" {
  value       = random_password.esxi_root_password.result
  sensitive   = true
  description = "The root password generated for the ESXi host."
}

output "ssl_thumbprint" {
  # need to add colons to make vCenter accept the thumbprint
  value       = join(":", [for x in range(0, 40, 2) : substr(data.tls_certificate.nested_esxi_certificate.certificates.0.sha1_fingerprint, x, 2)])
  description = "The thumbprint of the SSL certificate of the ESXi host in the format expected by the `vsphere_host` resource."
}
