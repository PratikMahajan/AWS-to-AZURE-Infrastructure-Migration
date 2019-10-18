#!/bin/sh
wget https://releases.hashicorp.com/terraform/0.12.10/terraform_0.12.10_linux_amd64.zip
unzip terraform_0.12.10_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm terraform_0.12.10_linux_amd64.zip
terraform --version
