#!/bin/false
# this is meant to be run on each master node

set -euxo pipefail

# add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# TODO really all stuff needed?
# TODO pin Docker version and apt mark hold





# sudo apt-get update
# sudo apt-get -y install socat conntrack ipset apt-transport-https ca-certificates curl gnupg2 software-properties-common

# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# sudo add-apt-repository "deb https://apt.kubernetes.io/ kubernetes-xenial main"
# sudo apt-get update

# # do not let docker interfer with networking:
# sudo mkdir -p /etc/systemd/system/docker.service.d/
# cat <<EOF | sudo tee /etc/systemd/system/docker.service.d/less-net.conf
# [Service]
# ExecStart=
# ExecStart=/usr/bin/dockerd -H fd://  --iptables=false --ip-masq=false
# EOF



# sudo apt-get install -y \
#   containerd.io=1.2.13-2 \
#   docker-ce=5:19.03.11~3-0~ubuntu-$(lsb_release -cs) \
#   docker-ce-cli=5:19.03.11~3-0~ubuntu-$(lsb_release -cs) \
#   "kubectl=${$KUBERNETES_VERSION}*"
# sudo apt-mark hold containerd.io docker-ce docker-ce-cli
