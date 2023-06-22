#!/bin/bash

set -euo pipefail

echo -e "\n\nInstall common packages..."
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    git \
    iputils-ping \
    netcat \
    libssl1.0 \
    gnupg \
    lsb-release

sudo apt-get update

# install Azure CLI & Azure DevOps extensions
echo -e "\n\nInstall Azure CLI"
curl -LsS https://aka.ms/InstallAzureCLIDeb | sudo bash 
az extension add --name azure-devops

# install dependent packages
echo -e "\n\nInstall dependent packages..."
sudo apt-get install -y --no-install-recommends \
    wget \
    unzip \
    apt-transport-https \
    software-properties-common

# install yq
echo -e "\n\nInstall yq"
wget https://github.com/mikefarah/yq/releases/download/v4.30.8/yq_linux_amd64 \
    && sudo mv ./yq_linux_amd64 /usr/bin/yq \
    && sudo chmod +x /usr/bin/yq

# install helm
echo -e "\n\nInstall helm"
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | sudo bash

# intall kubectl
echo -e "\n\nInstall kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && sudo mv ./kubectl /usr/bin/kubectl \
    && sudo chmod +x /usr/bin/kubectl

# install powershell core
echo -e "\n\nInstall PowerShell Core"
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" \
    && sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update && sudo apt-get install -y powershell

# download & extract the Azure DevOps Agent binaries
export AZDO_AGENT_VERSION="3.220.5"
echo -e "\n\nDownload and extract the Azure DevOps Agent Binaries v${AZDO_AGENT_VERSION}"
cd "$HOME"
wget -O agent-${AZDO_AGENT_VERSION}.tar.gz https://vstsagentpackage.azureedge.net/agent/${AZDO_AGENT_VERSION}/vsts-agent-linux-x64-${AZDO_AGENT_VERSION}.tar.gz
mkdir -p ./agent-01
cd agent-01
tar zxvf ../agent-${AZDO_AGENT_VERSION}.tar.gz

# install docker
echo -e "\n\nInstall Docker"
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# add current user into docker group
sudo usermod -aG docker "$USER"