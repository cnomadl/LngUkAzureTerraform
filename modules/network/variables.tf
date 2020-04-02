variable "resource_group_name" {
    description = "The name of the exisiting resource group to deploy network"
}

variable "allocation_method" {
  description = "Defines how an IP address is assigned. Options are Static or Dynamic."
  default = "Dynamic"
}

variable "nb_public_ip" {
  description = "Number of public IPs to assign corresponding to one IP per vm. Set to 0 to not assign any public IP addresses."
  default     = "1"
}

variable "address_space" {
    type = string
    description = "The address space that is used the virtual network"
    default     = "10.0.0.0/16"
}

# If no values specified, this defaults to Azure DNS 
variable "dns_servers" {
  description = "The DNS servers to be used with vNet."
  default     = []
}

variable "subnet_address_prefix" {
    description = "The prefixes of be used by the subnets. Multiple subnets use ["10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24"]"
    default     = ["10.0.1.0/24"]
}

variable "subnet_names" {
    description = "A list of subnets to use inside the Virtual Network e.g. ["subnet1, subnet2, subnet2"]"
    default     = ["default"]
}

variable "tags" {
  description = "The tags to associate with your network and subnets."
  type        = map(string)
  default     = {
    environment = "dev"
  }
}