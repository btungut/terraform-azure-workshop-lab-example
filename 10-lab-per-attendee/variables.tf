variable "corp_name" {
  type = string
  description = "The value that will be used to generate resource names. E.g.: contoso"
  #TODO: Implement validation, must be lowercase, etc.
}

variable "default_vm_size" {
  type = string
  default = "Standard_B4ms"
}

variable "default_linux_username" {
  type = string
  default = "azureuser"
}

variable "default_linux_ssh_private_key_path" {
  type = string
  default = "~/.ssh/id_rsa.pub"
}

variable "lab_number" {
  type = number
}