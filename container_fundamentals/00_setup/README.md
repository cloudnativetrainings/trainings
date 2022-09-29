# Provision VM with docker and podman installations

## Open Google Cloud Console Run the setup.sh bash script

You will be asked to enter the project name.

```bash
00_setup/setup.sh
```

## SSH into the new VM

```bash
gcloud compute ssh root@training-cf --zone europe-west3-a
```

## Install docker

```bash
# Update apt package index and install necessary dependencies
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Setup the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

## Add your user to the docker group

Do this to avoid use of `sudo` for each docker command. Note to put this change into effect, if you have to re-open the cloud shell.

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

## Install Podman

```bash
sudo apt-get update
sudo apt-get install -y podman
```

[Jump to Home](../README.md)
