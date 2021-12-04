variable "datacenter" {
  description = "The datacenter to deploy the virtual machines to."
  type = string
}

variable "networks" {
  description = "Define PortGroup and IPs/CIDR. If no CIDR provided, the subnet mask is taken from var.ipv4submask."
  type = map(string)
  default = null
}

variable "resource_pool" {
  description = "The resource pool to deploy the virtual machines to. If specifying a the root resource pool of a cluster, enter CLUSTER_NAME/Resources."
  type = string
}

variable "datastore" {
  description = "The datastore to deploy the virtual machines to."
  type = string
}

variable "template_name" {
  description = "The template to clone virtual machines from. Leave this blank when creating a virtual machine from scratch."
  type = string
  default = null
}

variable "host" {
  description = "The hypervisor host for the VM."
  type = string
}

variable "vm_name" {
  description = "The name and hostname for the virtual machine."
  type = string
}

variable "vm_folder" {
  description = "The name of the folder for this virtual machine."
  type        = string
  default     = ""
}

variable "num_cpus" {
  description = "The number of CPUs for this virtual machine."
  type        = number
  default     = 2
}

variable "cpu_reservation" {
  description = "The amount of CPU (in MHz) guaranteed for this virtual."
  type        = number
  default     = null
}

variable "memory" {
  description = "The amount of memory (in MB) for the virtual machine."
  type        = number
  default     = 4096
}

variable "num_cores_per_socket" {
  description = "The number of cores to distribute among the CPUs in this virtual machine. If specified, the value supplied to num_cpus must be evenly divisible by this value."
  type        = number
  default     = 1
}

variable "cpu_hot_add_enabled" {
  description = "Allow CPUs to be added to this virtual machine while it is running."
  type        = bool
  default     = null
}

variable "cpu_hot_remove_enabled" {
  description = "Allow CPUs to be removed to this virtual machine while it is running."
  type        = bool
  default     = null
}

variable "memory_hot_add_enabled" {
  description = "Allow memory to be added to this virtual machine while it is running."
  type        = bool
  default     = null
}

variable "memory_reservation" {
  description = "The amount of memory (in MB) guaranteed for this virtual machine."
  type        = number
  default     = null
}

variable "guest_id" {
  description = "The guest id of the virtual machine's operating system."
  type = string
}

variable "scsi_type" {
  description = "Type of scsi controller. acceptable values lsilogic, pvscsi."
  type        = string
  default     = "pvscsi"
}

variable "enable_disk_uuid" {
  description = "Expose the UUIDs of attached virtual disks to the virtual machine, allowing access to them in the guest."
  type        = bool
  default     = true
}

variable "disk_provisioning" {
  description = "Space for the vmdk disk allocated as needed. Acceptable values: thin, thick, sameAsSource"
  type        = string
  default     = "sameAsSource"
}

variable "eagerly_scrub" {
  description = "All allocated space for the vmdk is zeroed out.  If enabled, thin provisioned must be false."
  type        = bool
  default     = false
}

variable "network_type" {
  description = "The network type for each network interface."
  type        = string
  default     = null
}

variable "disks" {
  description = "Disks to add to the virtual machine."
  type        = map(map(string))
  default = {}
}

variable "dns_server_list" {
  description = "The DNS servers for the virtual machine to use"
  type = list(string)
}

variable "dns_suffix_list" {
  description = "The DNS suffixes for the virtual machine to search"
  type = list(string)
}

variable "gateway" {
  description = "The default gateway for the virtual machine"
  type = string
}

variable "domain" {
  description = "The default domain for the virtual machine"
  type = string
}

variable "hw_clock_utc" {
  description = "The hardware clock UTC status in the virtual machine"
  type = bool
  default = true
}

variable "content_library" {
  description = "The name of the content library storing the template."
  type = string
  default = null
}

variable "is_ovf" {
  description = "Is the deployment source an OVF/OVA file?"
  type = bool
  default = false
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

variable "vapp_properties" {
  description = "VApp properties to set on the vApp."
  default = null
}

variable "extra_config" {
  description = "Extra configuration options for the virtual machine."
  default = null
}

variable "template_os_family" {
  description = "The OS family of the template."
  type = string
  default = null
}