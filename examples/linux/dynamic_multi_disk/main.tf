module "virtual_machine" {
  source = "git@github.com:p5/terraform-vsphere-vm.git"

  datacenter = var.datacenter
  datastore = var.datastore
  resource_pool = var.resource_pool
  host = var.host

  template_name = var.template_name
  template_os_family = var.template_os_family

  vm_name = var.vm_name

  disks = var.disks

  dns_server_list = var.dns_server_list
  dns_suffix_list = [var.domain]
  domain = var.domain
  gateway = var.gateway
  guest_id = var.guest_id

  networks = var.networks
}