variable "ova_path" {
  type        = string
  default     = null
  description = "The full path to the ESXi OVA on the local system. If set, then `ova_url` should be explicitly set to `null`."
}

variable "ova_url" {
  type        = string
  default     = "https://download3.vmware.com/software/vmw-tools/nested-esxi/Nested_ESXi7.0u1_Appliance_Template_v1.ova"
  description = "The URL to the ESXi OVA. Must be set to `null` if a value is set for `ova_path`."
}

variable "folder_name" {
  type        = string
  description = "The name of the vm folder the nested ESXi Hosts should be created in."
}

variable "network_id" {
  type        = string
  description = "The ID of the network the nested ESXi Hosts should be attached to."
}

variable "datacenter_id" {
  type        = string
  description = "The ID of the dataceter the nested ESXi Hosts should be created in."
}

variable "resource_pool_id" {
  type        = string
  description = "The ID of the resource pool the nested ESXi Hosts should be created in."
}

variable "datastore_id" {
  type        = string
  description = "The ID of the datastore the nested ESXi Hosts should be created in."
}

variable "host_system_id" {
  type        = string
  description = "The ID of the host system that the nested ESXi OVA will be initially deployed on."
}

variable "enable_ssh" {
  type        = bool
  default     = true
  description = "Should SSH be enabled on the ESXi hosts.  Must be set to `true` presently so provisioners can run."

  validation {
    condition     = var.enable_ssh == true
    error_message = "Presently, the enable_ssh value must be `true` so that provisioners can run against the nested ESXi hosts."
  }
}

variable "hostname" {
  type        = string
  description = "The FQDN of the ESXi host. DNS records must exist ahead of provisioning or DDNS must be working in the environment."
}

variable "ip_address" {
  type        = string
  default     = ""
  description = "The IP address of the ESXi host. This defaults to \"\" which results in DHCP being used."
}

variable "mac_address" {
  type        = string
  default     = ""
  description = "The MAC address of the ESXi host. This defaults to \"\" which results in a MAC address being generated."
}

variable "cpu_count_override" {
  type        = number
  default     = 0
  description = "The number of CPUs each ESXi host should have.  Defaults to 0 which uses the CPU count of the OVA. The minimum CPU count is 2"

  validation {
    condition     = var.cpu_count_override == 0 || var.cpu_count_override >= 2
    error_message = "The cpu_count_override value must be equal to 0 or greater than or equal to 2."
  }
}

variable "memory_override" {
  type        = number
  default     = 0
  description = "The amount of memory each ESXi host should have. Defaults to 0 which uses the memory amount specified in the OVA. The minimum memory is 8192."

  validation {
    condition     = var.memory_override == 0 || var.memory_override >= 8192
    error_message = "The memory_override value must be equal to 0 or greater than or equal to 8192."
  }
}

variable "enable_vsan" {
  type        = bool
  default     = true
  description = "Should vSAN be enabled on the nested ESXi host?"
}

variable "dns" {
  type        = string
  default     = ""
  description = "The DNS server(s) for the nested ESXi host. This defaults to \"\" which results in DHCP being used. Must be set if a static IP is set in `ip_address`."
}

variable "ntp" {
  type        = string
  default     = "pool.ntp.org"
  description = "The NTP server for the nested ESXi host. Defaults to \"pool.ntp.org\"."
}

variable "netmask" {
  type        = string
  default     = ""
  description = "The netmask of the nested ESXi host. This defaults to \"\". Must be set if a static IP is set in `ip_address`."
}

variable "gateway" {
  type        = string
  default     = ""
  description = "The gateway of the nested ESXi host. This defaults to \"\". Must be set if a static IP is set in `ip_address`."
}

variable "syslog" {
  type        = string
  default     = ""
  description = "The syslog server the nested ESXi host should send logs to. Defaults to \"\" which results in remote syslog not being configured."
}

variable "vlan_id" {
  type        = number
  default     = null
  description = "The VLAN ID the management interface uses. Defaults to `null` which results in one not being configured."
}
