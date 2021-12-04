provider "vsphere" {
  user = "HashiCorp@vsphere.local"
  password = "password"
  allow_unverified_ssl = true
  vsphere_server = "vcsa.sturla.uk"
}
