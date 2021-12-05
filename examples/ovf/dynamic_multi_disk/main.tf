module "virtual_machine" {
  source = "git@github.com:p5/terraform-vsphere-vm.git"

  datacenter = var.datacenter
  datastore = var.datastore
  resource_pool = var.resource_pool
  host = var.host

  vm_name = var.vm_name

  is_ovf = true
  ovf_remote_url = "https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.ova"

  disks = var.disks

  dns_server_list = var.dns_server_list
  dns_suffix_list = [var.domain]
  domain = var.domain
  gateway = var.gateway
  guest_id = var.guest_id

  networks = var.networks
}