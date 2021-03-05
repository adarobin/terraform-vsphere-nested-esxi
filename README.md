# Nested ESXi Terraform Module

Terraform module which creates a nested ESXi virtual machine in a vSphere environment.

Presently, this module does not work with the official `terraform-provider-vsphere`. You must compile the provider from
[#1339](https://github.com/hashicorp/terraform-provider-vsphere/pull/1339).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| random | n/a |
| tls | n/a |
| vsphere | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [random_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) |
| [tls_certificate](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) |
| [vsphere_ovf_vm_template](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/ovf_vm_template) |
| [vsphere_virtual_machine](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cpu\_count\_override | The number of CPUs each ESXi host should have.  Defaults to 0 which uses the CPU count of the OVA. The minimum CPU count is 2 | `number` | `0` | no |
| datacenter\_id | The ID of the dataceter the nested ESXi Hosts should be created in. | `string` | n/a | yes |
| datastore\_id | The ID of the datastore the nested ESXi Hosts should be created in. | `string` | n/a | yes |
| dns | The DNS server(s) for the nested ESXi host. This defaults to "" which results in DHCP being used. Must be set if a static IP is set in `ip_address`. | `string` | `""` | no |
| enable\_ssh | Should SSH be enabled on the ESXi hosts.  Must be set to `true` presently so provisioners can run. | `bool` | `true` | no |
| enable\_vsan | Should vSAN be enabled on the nested ESXi host? | `bool` | `true` | no |
| folder\_name | The name of the vm folder the nested ESXi Hosts should be created in. | `string` | n/a | yes |
| gateway | The gateway of the nested ESXi host. This defaults to "". Must be set if a static IP is set in `ip_address`. | `string` | `""` | no |
| host\_system\_id | The ID of the host system that the nested ESXi OVA will be initially deployed on. | `string` | n/a | yes |
| hostname | The FQDN of the ESXi host. DNS records must exist ahead of provisioning or DDNS must be working in the environment. | `string` | n/a | yes |
| ip\_address | The IP address of the ESXi host. This defaults to "" which results in DHCP being used. | `string` | `""` | no |
| mac\_address | The MAC address of the ESXi host. This defaults to "" which results in a MAC address being generated. | `string` | `""` | no |
| memory\_override | The amount of memory each ESXi host should have. Defaults to 0 which uses the memory amount specified in the OVA. The minimum memory is 8192. | `number` | `0` | no |
| netmask | The netmask of the nested ESXi host. This defaults to "". Must be set if a static IP is set in `ip_address`. | `string` | `""` | no |
| network\_id | The ID of the network the nested ESXi Hosts should be attached to. | `string` | n/a | yes |
| ntp | The NTP server for the nested ESXi host. Defaults to "pool.ntp.org". | `string` | `"pool.ntp.org"` | no |
| ova\_path | The full path to the ESXi OVA on the local system. If set, then `ova_url` should be explicitly set to "". | `string` | `""` | no |
| ova\_url | The URL to the ESXi OVA. Must be set to "" if a value is set for `ova_path`. | `string` | `"https://download3.vmware.com/software/vmw-tools/nested-esxi/Nested_ESXi7.0u1_Appliance_Template_v1.ova"` | no |
| resource\_pool\_id | The ID of the resource pool the nested ESXi Hosts should be created in. | `string` | n/a | yes |
| syslog | The syslog server the nested ESXi host should send logs to. Defaults to "" which results in remote syslog not being configured. | `string` | `""` | no |
| vlan\_id | The VLAN ID the management interface uses. Defaults to `null` which results in one not being configured. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| root\_password | n/a |
| ssl\_thumbprint | n/a |
| vsan\_cache\_disks | n/a |
| vsan\_capacity\_disks | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->