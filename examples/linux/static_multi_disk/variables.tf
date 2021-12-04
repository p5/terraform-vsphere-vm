variable "datacenter" {}
variable "datastore" {}
variable "resource_pool" {}
variable "host" {}

variable "template_name" {}
variable "template_os_family" {}

variable "vm_name" {}

variable "disks" {}

variable "dns_server_list" {}
variable "domain" {}
variable "gateway" {}
variable "guest_id" {}

variable "networks" {
  type = map(string)
}