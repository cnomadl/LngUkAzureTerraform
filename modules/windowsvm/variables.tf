variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created"
}

variable "admin_username" {
  description = "The admin username to be used on the VM(s) that will be deployed."
  default     = ""
}

variable "admin_password" {
  description = "The admin password to be used on the VM(s) that will be deployed. The password must meet the complexity requirements of Azure"
  default     = ""
}

variable "storage_account_type" {
  description = "Defines the type of storage account to be created. Valid options are Standard_LRS, Standard_ZRS, Standard_GRS, Standard_RAGRS, Premium_LRS."
  default     = "Standard_LRS"
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_D2s_v3"
}

variable "nb_instances" {
  description = "Specify the number of vm instances"
  default     = "1"
}

variable "vm_hostname" {
  description = "The Virtuam Machine hostname"
  default     = "myvm"
}

variable "vm_os_simple" {
  description = "Specify UbuntuServer, WindowsServer, RHEL, openSUSE-Leap, CentOS, Debian, CoreOS and SLES to get the latest image version of the specified os.  Do not provide this value if a custom value is used for vm_os_publisher, vm_os_offer, and vm_os_sku."
  type        = string
  default     = ""
}

variable "vm_os_id" {
  description = "The resource ID of the image that you want to deploy if you are using a custom image.Note, need to provide is_windows_image = true for windows custom images."
  default     = ""
}

variable "is_windows_image" {
  type        = bool 
  description = "Boolean flag to notify when the custom image is windows based."
  default     = false
}

variable "vm_os_publisher" {
  description = "The name of the publisher of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  default     = ""
}

variable "vm_os_offer" {
  description = "The name of the offer of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  default     = ""
}

variable "vm_os_sku" {
  description = "The sku of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  default     = ""
}

variable "vm_os_version" {
  description = "The version of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  default     = "latest"
}

variable "nb_data_disk" {
  description = "(Optional) Number of the data disks attached to each virtual machine"
  default     = 0
}

variable "delete_os_disk_on_termination" {
  type        = bool
  description = "Delete datadisk when machine is terminated"
  default     = true
}

variable "data_sa_type" {
  description = "Data Disk Storage Account type"
  default     = "Standard_LRS"
}

variable "data_disk_size_gb" {
  description = "Storage data disk size size"
  default     = 30
}

variable "boot_diagnostics" {
  type        = bool
  description = "(Optional) Enable or Disable boot diagnostics"
  default     = false
}

variable "boot_diagnostics_sa_type" {
  description = "(Optional) Storage account type for boot diagnostics"
  default     = "Standard_LRS"
}

variable "enable_accelerated_networking" {
  type        = bool
  description = "(Optional) Enable accelerated networking on Network interface"
  default     = false
}

variable "tags" {
    type = map(string)
    description = "A map of the tags to use on the resources that you are deploying with htis module"
    default = {
        environment = "dev"
    }
}

