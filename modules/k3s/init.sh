#!/bin/bash
set -euo pipefail

sudo apt-get update -y
export INSTALL_K3S_EXEC="server --disable traefik --disable-helm-controller" && curl -sfL https://get.k3s.io | sh -
sudo sed "s/127.0.0.1/$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)/g" /etc/rancher/k3s/k3s.yaml | tee "$HOME/kubeconfig.yaml"