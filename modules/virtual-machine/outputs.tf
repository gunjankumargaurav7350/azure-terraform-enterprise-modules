output "vm_ids" { value = { for k, v in azurerm_linux_virtual_machine.this : k => v.id } }
output "nic_ids" { value = { for k, v in azurerm_network_interface.this : k => v.id } }
