resource "vsphere_virtual_machine" "virtual_machine_linux" {
  count = !var.is_ovf && (var.template_os_family == "linux")  ? 1 : 0
  name             = var.vm_name

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

  # Template disks
  dynamic "disk" {
    for_each = data.vsphere_virtual_machine.template[0].disks
    iterator = template_disks
    content {
      label = "disk${template_disks.key}"
      size = data.vsphere_virtual_machine.template[0].disks[template_disks.key].size
      unit_number = template_disks.key
    }
  }

  # Additional disks
  dynamic "disk" {
    for_each = var.disks
    iterator = disks
    content {
      label            = disks.key
      unit_number      = index(keys(var.disks), disks.key) + 1
      size             = lookup(disks.value, "size_gb", null)
      thin_provisioned = lookup(disks.value, "thin_provisioned", "true")
      eagerly_scrub    = lookup(disks.value, "eagerly_scrub", "false")
      datastore_id = data.vsphere_datastore.datastore.id
    }
  }

  cdrom {
    client_device = true
  }

  clone {
    template_uuid = var.content_library == null ? data.vsphere_virtual_machine.template[0].id : data.vsphere_content_library_item.library_item_template[0].id

    customize {
      linux_options {
        host_name    = var.vm_name
        domain       = var.domain
        hw_clock_utc = var.hw_clock_utc

      }

      dynamic "network_interface" {
        for_each = keys(var.networks)
        content {
          ipv4_address = split("/", var.networks[keys(var.networks)[network_interface.key]])[0]
          ipv4_netmask = split("/", var.networks[keys(var.networks)[network_interface.key]])[1]
        }
      }

      dns_server_list = var.dns_server_list
      dns_suffix_list = var.dns_suffix_list
      ipv4_gateway    = var.gateway

    }
  }

  lifecycle {
    ignore_changes = [
      annotation,
      tags
    ]
  }
}