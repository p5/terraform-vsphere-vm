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
variable "ovf_remote_url" {
  default = null
  description = "The remote URL for the OVF/OVA file."
  type = string
}

variable "ovf_local_url" {
  default = null
  description = "The local URL for the OVF/OVA file."
  type = string
}

variable "ovf_allow_unverified_ssl" {
  default = false
  description = "Allow unverified SSL certificates when downloading the OVF/OVA file."
  type = bool
}