# Nested ESXi Terraform Module

Terraform module which creates a nested ESXi virtual machine in a vSphere environment.

This currently works with the [VirtuallyGhetto](https://www.virtuallyghetto.com/nested-virtualization/nested-esxi-virtual-appliance)
Nested ESXi Appliances.

It has been tested with vSphere 7.0 Update 1 (and currently defaults to using that image). It will likely work with at least some of
the other images available.

There is a known issue with this module and vSphere 7.0 Update 2. This release defaults to having
[SHA-1 disabled for SSH connections](https://docs.vmware.com/en/VMware-vSphere/7.0/rn/vsphere-vcenter-server-702-release-notes.html#productsupport).
This prevents Terraform from being able to connect to the host with SSH after deployment due to [#37278](https://github.com/golang/go/issues/37278) in golang.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| vsphere | >= 1.25.0 |

## Providers

| Name | Version |
|------|---------|
| random | n/a |
| tls | n/a |
| vsphere | >= 1.25.0 |

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
| ova\_path | The full path to the ESXi OVA on the local system. If set, then `ova_url` should be explicitly set to `null`. | `string` | `null` | no |
| ova\_url | The URL to the ESXi OVA. Must be set to `null` if a value is set for `ova_path`. | `string` | `"https://download3.vmware.com/software/vmw-tools/nested-esxi/Nested_ESXi7.0u1_Appliance_Template_v1.ova"` | no |
| resource\_pool\_id | The ID of the resource pool the nested ESXi Hosts should be created in. | `string` | n/a | yes |
| syslog | The syslog server the nested ESXi host should send logs to. Defaults to "" which results in remote syslog not being configured. | `string` | `""` | no |
| vlan\_id | The VLAN ID the management interface uses. Defaults to `null` which results in one not being configured. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| root\_password | The root password generated for the ESXi host. |
| ssl\_thumbprint | The thumbprint of the SSL certificate of the ESXi host in the format expected by the `vsphere_host` resource. |
| vsan\_cache\_disks | A list of available vSAN cache disks. |
| vsan\_capacity\_disks | A list of available vSAN capacity disks. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->