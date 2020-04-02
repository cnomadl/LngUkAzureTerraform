##############################################################################
# * Modules
##############################################################################
module "os" {
  source = "./modules/os"
  vm_os_simple = var.vm_os_simple  
}

##############################################################################
# Azure Resource Group
##############################################################################
data "azurerm_resource_group" "wvm_rg" {
    name = var.resource_group_name   
}

resource "random_id" "vm_sa" {
    keepers = {
        vm_hostname = var.vm_hostname
    }

    byte_length = 6
}

##############################################################################
# * Create a Storage Account for Boot Diagnostics
##############################################################################
resource "azurerm_storage_account" "vm_sa" {
  count                    = var.boot_diagnostics ? 1 : 0
  name                     = "bootdiag${lower(random_id.ba_vm_sa.hex)}"
  resource_group_name      = data.azurerm_resource_group.wvm_rg.name
  location                 = data.azurerm_resource_group.wvm_rg.location
  account_tier             = element(split("_", var.boot_diagnostics_sa_type), 0)
  account_replication_type = element(split("_", var.boot_diagnostics_sa_type), 1)
  tags                     = var.tags
}

##############################################################################
# * Build a Windows Virtual machine
##############################################################################
resource "azurerm_virtual_machine" "windows-vm" {
  count                         = (var.is_windows_image || contains(list(var.vm_os_simple, var.vm_os_offer), "Windows")) ? var.nb_instances : 0
  name                          = "${var.vm_hostname}-${var.initials}-${count.index}"
  resource_group_name           = data.azurerm_resource_group.wvm_vm.name
  location                      = data.azurerm_resource_group.wvm_vm.location
  availability_set_id           = azurerm_availability_set.vm.id
  vm_size                       = var.vm_size
  network_interface_ids         = [element(azurerm_network_interface.vm.*.id, count.index)]
  delete_os_disk_on_termination = var.delete_os_disk_on_termination

  storage_image_reference {
    id        = var.vm_os_id
    publisher = var.vm_os_id == "" ? coalesce(var.vm_os_publisher, module.os.calculated_value_os_publisher) : ""
    offer     = var.vm_os_id == "" ? coalesce(var.vm_os_offer, module.os.calculated_value_os_offer) : ""
    sku       = var.vm_os_id == "" ? coalesce(var.vm_os_sku, module.os.calculated_value_os_sku) : ""
    version   = var.vm_os_id == "" ? var.vm_os_version : ""
  }

  storage_os_disk {
    name              = "${var.vm_hostname}-${count.index}-osdisk"
    create_option     = "FromImage"
    caching           = "ReadWrite"
    managed_disk_type = var.storage_account_type
  }

  dynamic storage_data_disk {
    for_each = range(var.nb_data_disk)
    content {
      name              = "${var.vm_hostname}-${count.index}-datadisk-${storage_data_disk.value}"
      create_option     = "Empty"
      lun               = storage_data_disk.value
      disk_size_gb      = var.data_disk_size_gb
      managed_disk_type = var.data_sa_type
    }
  }

  os_profile {
    computer_name  = "${var.vm_hostname}-${count.index}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  tags = var.tags

  os_profile_windows_config {
    provision_vm_agent = true
  }

  boot_diagnostics {
    enabled     = var.boot_diagnostics
    storage_uri = var.boot_diagnostics ? join(",", azurerm_storage_account.vm_sa.*.primary_blob_endpoint) : ""
  }
}

##############################################################################
# * Create a network interface for the VM
##############################################################################
resource "azurerm_network_interface" "vm_nic" {
    count                         = var.nb_instances
    name                          = "${var.vm_hostname}-${count.index}-nic"
    location                      = data.azurerm_resource_group.wvm_rg.location
    resource_group_name           = data.azurerm_resource_group.wvm_rg.name
    enable_accelerated_networking = var.enable_accelerated_networking

    ip_configuration {
        name                          ="${var.vm_hostname}-${count.index}-ip"
        subnet_id                     = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = length(module.network.azurerm_public_ip.pip.*.id) > 0 ? element(concat(module.network.azurerm_public_ip.pip.*.id, list("")), count.index) : ""
#        public_ip_address_id          = length(module.network.public_ip_pip) > 0 ? element(concat(module.network.public_ip_pip, list("")), count.index) : ""
    }
}

##############################################################################
# * Associate the Network Interface with the Security Group
##############################################################################
resource "azurerm_network_interface_security_group_association" "nsga" {
    count                     = var.nb_instances
    network_interface_id      = azurerm_network_interface.vm_nic[count.index].id
    network_security_group_id = azurerm_network_security_group.ba_nsg.id
}