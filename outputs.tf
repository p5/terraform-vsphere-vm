output "default_ip_address" {
  value = flatten(tolist([
    vsphere_virtual_machine.virtual_machine_linux.*.default_ip_address,
    vsphere_virtual_machine.virtual_machine_ovf.*.default_ip_address
  ]))
}

output "id" {
  value = flatten(tolist([
    vsphere_virtual_machine.virtual_machine_linux.*.id,
    vsphere_virtual_machine.virtual_machine_ovf.*.id
  ]))
}

output "alternate_ip_addresses" {
  value = flatten(tolist([
    vsphere_virtual_machine.virtual_machine_linux.*.guest_ip_addresses,
    vsphere_virtual_machine.virtual_machine_ovf.*.guest_ip_addresses
  ]))
}