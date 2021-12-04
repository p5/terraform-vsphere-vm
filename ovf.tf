resource "vsphere_virtual_machine" "virtual_machine_ovf" {
  count = var.is_ovf ? 1 : 0
  name             = var.vm_name

  datacenter_id = data.vsphere_datacenter.datacenter.id
  resource_pool_id = data.vsphere_compute_cluster.cluster[0].resource_pool_id
  host_system_id = data.vsphere_host.host[0].id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vm_folder

  num_cpus               = var.num_cpus
  num_cores_per_socket   = var.num_cores_per_socket
  cpu_hot_add_enabled    = var.cpu_hot_add_enabled
  cpu_hot_remove_enabled = var.cpu_hot_remove_enabled
  cpu_reservation        = var.cpu_reservation
  memory_reservation     = var.memory_reservation
  memory                 = var.memory
  memory_hot_add_enabled = var.memory_hot_add_enabled

  guest_id         = var.guest_id
  scsi_type        = var.scsi_type
  enable_disk_uuid = var.enable_disk_uuid

  network_interface {
    network_id   = data.vsphere_network.network[0].id
    adapter_type = var.network_type
  }

  ovf_deploy {
    local_ovf_path = var.ovf_local_url
    remote_ovf_url = var.ovf_remote_url
    allow_unverified_ssl_cert = var.ovf_allow_unverified_ssl
  }

  # Additional disks
  dynamic "disk" {
    for_each = var.disks
    iterator = disks
    content {
      label            = disks.key
      unit_number      = index(keys(var.disks), disks.key)
      size             = lookup(disks.value, "size_gb", null)
      thin_provisioned = lookup(disks.value, "thin_provisioned", "true")
      eagerly_scrub    = lookup(disks.value, "eagerly_scrub", "false")
      datastore_id     = lookup(disks.value, "datastore_id", null)
    }
  }

  cdrom {
    client_device = true
  }

  vapp {
    properties = var.vapp_properties
  }

  extra_config = var.extra_config

  lifecycle {
    ignore_changes = [
      annotation,
      tags
    ]
  }
}