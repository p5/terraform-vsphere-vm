datacenter = "Datacenter"
datastore = "HPDS01"
resource_pool = "Cluster"
host = "rs-esxi-02.sturla.uk"

template_name = "Ubuntu Server 20.04 Template"
template_os_family = "linux"
guest_id = "ubuntu64Guest"

vm_name = "linux-dynamic-single-disk"

dns_server_list = ["1.1.1.1"]
domain = "example.com"

gateway = "172.32.255.1"
networks = {
  "Temporary" = "172.32.255.100/24"
}