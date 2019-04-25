#/bin/bash

function install_azure_az {
sudo apt install -y curl apt-transport-https lsb-release gpg
curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
  gpg --dearmor | \
    sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null

AZ_REPO=$(lsb_release -cs | sed s/buster/stretch/ )
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    sudo tee /etc/apt/sources.list.d/azure-cli.list

sudo apt update
sudo apt install azure-cli
}

function install_azure_dbfs {
  pip install databricks-cli
}

install_azure_az && install_azure_dbfs
