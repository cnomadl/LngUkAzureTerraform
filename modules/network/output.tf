output "public_ip_id" {
  description = "Id of the public IP address provisioned"
  value       = azurerm_public_ip.pip.*.id
}

output "public_ip_address" {
  description = "The actual ip address allocated for the resource."
  value       = azurerm_public_ip.pip.*.ip_address
}

output "public_ip_dns_name" {
  description = "fqdn to connect to the first vm provisioned."
  value       = azurerm_public_ip.pip.*.fqdn
}

output "vnet_id" {
  description = "The id of the newly created vNet"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "The Name of the newly created vNet"
  value       = azurerm_virtual_network.vnet.name
}

output "vnet_location" {
  description = "The location of the newly created vNet"
  value       = azurerm_virtual_network.vnet.location
}

output "vnet_address_space" {
  description = "The address space of the newly created vNet"
  value       = azurerm_virtual_network.vnet.address_space
}

output "vnet_subnets" {
  description = "The ids of subnets created inside the newl vNet"
  value       = azurerm_subnet.subnet.*.id
}

