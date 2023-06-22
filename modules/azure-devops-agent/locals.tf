locals {
  init_script_path          = "${path.module}/init.sh"
  init_script_basename      = basename(local.init_script_path)
  init_script_src_abs_path  = abspath(local.init_script_path)
  init_script_dest_abs_path = abspath("/home/${var.vm_username}/${local.init_script_basename}")
}
