output "default_ip_address" {
  value = module.virtual_machine.default_ip_address
}

output "id" {
  value = module.virtual_machine.id
}

output "network" {
  value = module.virtual_machine.alternate_ip_addresses
}