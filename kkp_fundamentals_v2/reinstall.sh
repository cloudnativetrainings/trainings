#!/bin/bash

export GOOGLE_CREDENTIALS=$(cat ~/key.json)
export KUBEONE_VERSION=1.4.4
export KKP_VERSION=2.20.2

eval `ssh-agent`
ssh-add ~/.ssh/kkp_admin_training

sudo apt-get install -y uuid-runtime apache2-utils 

curl -L https://github.com/kubermatic/kubeone/releases/download/v1.4.4/kubeone_1.4.4_linux_amd64.zip --output ~/tmp/kubeone.zip
mkdir -p ~/tmp/kubeone
rm -rf ~/tmp/kubeone/*
unzip ~/tmp/kubeone.zip -d ~/tmp/kubeone
chmod +x ~/tmp/kubeone/kubeone
sudo cp ~/tmp/kubeone/kubeone /usr/local/bin

#curl -L https://github.com/kubermatic/kubermatic/releases/download/v2.20.2/kubermatic-ce-v2.20.2-linux-amd64.tar.gz --output ~/tmp/kubermatic-ce.tar.gz
mkdir -p ~/tmp/kkp
rm -rf ~/tmp/kkp/*
tar -xvf ~/tmp/kubermatic-ce.tar.gz -C ~/tmp/kkp	
chmod +x ~/tmp/kkp/kubermatic-installer
sudo cp ~/tmp/kkp/kubermatic-installer /usr/local/bin