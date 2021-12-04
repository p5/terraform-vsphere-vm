data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}

data "vsphere_compute_cluster" "cluster" {
  count         = var.resource_pool != "" ? 1 : 0
  name          = var.resource_pool
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
  count         = var.host != "" ? 1 : 0
  name          = var.host
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  count         = var.networks != null ? length(var.networks) : 0
  name          = keys(var.networks)[count.index]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  count         = var.template_name != null ? 1 : 0
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_content_library" "library" {
  count      = var.content_library != null ? 1 : 0
  name       = var.content_library
}

data "vsphere_content_library_item" "library_item_template" {
  count      = var.content_library != null ? 1 : 0
  library_id = data.vsphere_content_library.library[0].id
  type       = "ovf"
  name       = var.template_name
}