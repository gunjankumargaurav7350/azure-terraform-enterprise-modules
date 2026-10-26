resource "azurerm_network_interface" "this" {
  for_each            = var.vms
  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "this" {
  for_each                        = var.vms
  name                            = each.key
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = each.value.size
  admin_username                  = each.value.admin_username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.this[each.key].id]
  zone                            = try(each.value.zone, null)

  admin_ssh_key {
    username   = each.value.admin_username
    public_key = var.admin_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = each.value.os_disk_type
  }

  source_image_reference {
    publisher = each.value.image.publisher
    offer     = each.value.image.offer
    sku       = each.value.image.sku
    version   = each.value.image.version
  }

  tags = var.tags
}

resource "azurerm_managed_disk" "this" {
  for_each             = var.data_disks
  name                 = "${each.key}-disk"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = each.value.storage_account_type
  create_option        = "Empty"
  disk_size_gb         = each.value.disk_size_gb
  zone                 = try(each.value.zone, null)
  tags                 = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "this" {
  for_each           = var.data_disks
  managed_disk_id    = azurerm_managed_disk.this[each.key].id
  virtual_machine_id = azurerm_linux_virtual_machine.this[each.value.vm_key].id
  lun                = each.value.lun
  caching            = each.value.caching
}
