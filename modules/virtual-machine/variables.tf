variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "admin_ssh_public_key" { type = string }
variable "vms" {
  type = map(object({
    size           = string
    admin_username = string
    subnet_id      = string
    os_disk_type   = string
    zone           = optional(string)
    image = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
  }))
  default = {}
}
variable "data_disks" {
  type = map(object({
    vm_key               = string
    lun                  = number
    caching              = string
    disk_size_gb         = number
    storage_account_type = string
    zone                 = optional(string)
  }))
  default = {}
}
variable "tags" { type = map(string); default = {} }
