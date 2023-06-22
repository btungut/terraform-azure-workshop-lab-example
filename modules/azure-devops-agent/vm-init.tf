resource "null_resource" "vm_init_script_file" {
  depends_on = [
    azurerm_linux_virtual_machine.agent
  ]

  connection {
    host        = azurerm_linux_virtual_machine.agent.private_ip_address
    type        = "ssh"
    user        = var.vm_username
    private_key = file(abspath(pathexpand(var.vm_ssh_private_key)))
    agent       = "false"
  }
  provisioner "file" {
    source      = local.init_script_src_abs_path
    destination = local.init_script_dest_abs_path
  }
}

resource "null_resource" "vm_init_script_file_exec" {
  depends_on = [
    azurerm_linux_virtual_machine.agent,
    null_resource.vm_init_script_file
  ]

  connection {
    host        = azurerm_linux_virtual_machine.agent.private_ip_address
    type        = "ssh"
    user        = var.vm_username
    private_key = file(abspath(pathexpand(var.vm_ssh_private_key)))
    agent       = "false"
  }
  provisioner "remote-exec" {
    inline = [
      "#!/bin/bash",
      "set -euo pipefail",
      "chmod +x ${local.init_script_dest_abs_path}",
      "bash ${local.init_script_dest_abs_path}"
    ]
  }
}