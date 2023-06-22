variable "corp_name" {
  type = string
  description = "The value that will be used to generate resource names. E.g.: contoso"
  #TODO: Implement validation, must be lowercase, etc.
}

variable "default_vm_size" {
  type = string
  default = "Standard_B4ms"
}



variable "ssh_private_key_path" {
  type        = string
  description = "Path of the private key. E.g.: ~/.ssh/id_rsa"
  validation {
    condition     = fileexists(var.ssh_private_key_path)
    error_message = "Private key does not exist!"
  }
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path of the public key. E.g.: ~/.ssh/id_rsa.pub"
  validation {
    condition     = fileexists(var.ssh_public_key_path)
    error_message = "Public key does not exist!"
  }
}


variable "lab_number" {
  type = number
  validation {
    condition = var.lab_number >= 1 && var.lab_number <= 12
    error_message = "Lab number should be between 1 and 12"
  }
}