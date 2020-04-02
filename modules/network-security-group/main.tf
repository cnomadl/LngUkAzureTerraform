data "azurerm_resource_group" "nsg" {
    name = var.resource_group_name
}

##############################################################################
# * Create a Network Security Group
##############################################################################
resource "azurerm_network_security_group" "nsg" {
    name                = "${var.resource_group_name}-nsg"
    location            = data.azurerm_resource_group.nsg.location
    resource_group_name = data.azurerm_resource_group.nsg.name
    tags                = var.tags
}

##############################################################################
# * Create Network Security Group Rules to Allow Indound Access
##############################################################################
resource "azurerm_network_security_rule" "nsg_rule" {
    name                        = "allow_remote_${coalesce(var.remote_port, module.os.calculated_remote_port)}_in_all"
    resource_group_name         = data.azurerm_resource_group.nsg.name
    description                 = "Allow remote protocol in from all locations"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = coalesce(var.remote_port, module.os.calculated_remote_port)
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    network_security_group_name = azurerm_network_security_group.nsg.name
}