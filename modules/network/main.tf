data "aurerm_resource_group" "network" {
    name = var.resource_group_name
}

##############################################################################
# * Create a Public IP
##############################################################################
resource "azurerm_public_ip" "pip" {
  count               = var.nb_public_ip
  name                = "${var.vm_hostname}-${count.index}-pip"
  resource_group_name = data.azurerm_resource_group.network.name
  location            = data.azurerm_resource_group.network.location
  allocation_method   = var.allocation_method
  domain_name_label   = "${lower(var.dns_label)}-${lower(var.vm_hostname)}${count.index}"
  tags                = var.tags
}

##############################################################################
# * Create a Virtual Network
##############################################################################
resource "azurerm_virtual_network" "vnet" {
    name                = "${var.resource_group_name}-vnet"
    location            = data.azurerm_resource_group.network.location
    resource_group_name = data.azurerm_resource_group.network.name
    address_space       = [var.address_space]
    dns_server          = var.dns_server
    tags                = var.tags
}

##############################################################################
# * Create a Subnet(s) for the Virtual Network
##############################################################################
resource "azurerm_subnet" "subnet" {
    count                = length(var.subnet_names)
    name                 = var.subnet_names[count.index]
    resource_group_name  = data.azurerm_resource_group.network.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefix       = var.subnet_address_prefix[count.index]
}