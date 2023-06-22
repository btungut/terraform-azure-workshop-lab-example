variable "vnet_rg_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "vnet_subnet_name" {
  type = string
}

variable "vm_rg_name" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "vm_size" {
  type    = string
}

variable "vm_ip_address" {
  type= string
  validation {
    condition = can(regex("/(^127\\.)|(^192\\.168\\.)|(^10\\.)|(^172\\.1[6-9]\\.)|(^172\\.2[0-9]\\.)|(^172\\.3[0-1]\\.)|(^::1$)|(^[fF][cCdD])/", var.vm_ip_address))
    error_message = "vm_ip_address must be a valid private ip address"
  }
}

variable "vm_username" {
  type    = string
}

variable "vm_ssh_private_key" {
  type    = string
}

variable "vm_ssh_public_key" {
  type    = string
}
