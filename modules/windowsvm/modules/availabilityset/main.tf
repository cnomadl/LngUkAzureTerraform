data "azurerm_resource_group" "vm_as"{
  name = var.resource_group_name
}

resource "azurerm_availability_set" "windows_vm_as" {
  name                         = "${var.vm_hostname}-avset"
  resource_group_name          = data.azurerm_resource_group.vm_as.name
  location                     = data.azurerm_resource_group.vm_as.location
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
  tags                         = var.tags
}