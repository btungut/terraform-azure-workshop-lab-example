locals {
  lab_number           = format("%02s", var.lab_number)
  resource_name_prefix = "${var.corp_name}-${local.lab_number}"
  kubeconfig_file_name = "kubeconfig.yaml"
  linux_username       = "azureuser"
  k3s_vm_post_install_script = jsonencode({
    "commandToExecute" = <<EOF
          sudo apt-get update -y &&
          export INSTALL_K3S_EXEC="server --disable traefik --disable-helm-controller" && curl -sfL https://get.k3s.io | sh - &&
          sudo sed "s/127.0.0.1/$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)/g" /etc/rancher/k3s/k3s.yaml > "/home/azureuser/${local.kubeconfig_file_name}" &&
          echo "Completed!"
          EOF
  })
}
