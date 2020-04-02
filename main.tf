##############################################################################
# * Virtual Machine Deployment Using Terraform on Azure
# 
# This Terraform configuration will create the following:
#
# Resource group with a virtual network and subnet
# An Ubuntu Linux server running Apache
##############################################################################

module "network-security-group" {
    source = "./modules/"
#    resource_group_name = ""
    remote_port ="3389"
    tags = ""
}

module "network" {
    source                 = "./modules/"
#    resource_group_name    = ""
    nb_public_ip           = 1
    allocation_method      = "Dynamic"
    dns_label              = "baltic"
#    allow_rdp_traffic     = true
#    allow_ssh_traffic     = false
#    address_space         = ["10.0.0.0/16"]
#    subnet_address_prefix = ["10.0.1.0/24"]
#    subnet_names          = ["subnet1"]
    tags                   = {}
}

module "windowsvm" {
    source = "./modules/"
#    resource_group_name           = var.resource_group_name
    vm_hostname                   = ""
    admin_username                = ""
    admin_password                = ""    
    nb_instances                  = 1
    vm_os_publisher               = "MicrosoftWindowsServer"
    vm_os_offer                   = "WindowsServer"
    vm_os_sku                     = "2012-R2-Datacenter"
#    vm_size                       = "Standard_DS2_V2"
    vnet_subnet_id                = module.network.vnet_subnet[1]
    enable_accelerated_networking = false


}