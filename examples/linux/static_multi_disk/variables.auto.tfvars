datacenter = "Datacenter"
datastore = "HPDS01"
resource_pool = "Cluster"
host = "rs-esxi-02.sturla.uk"

template_name = "Ubuntu Server 20.04 Template"
template_os_family = "linux"
guest_id = "ubuntu64Guest"

vm_name = "linux-static-multi-disk"

disks = {
  "disk1" = {
    size_gb          = 32
    thin_provisioned = true
    eagerly_scrub    = false
  }
  "disk2" = {
    size_gb = 32
  }
}

dns_server_list = ["1.1.1.1"]
domain = "example.com"

gateway = "172.32.255.1"
networks = {
  "Temporary" = "172.32.255.100/24"
}