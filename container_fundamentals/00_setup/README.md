# Provision VM and install docker

## Run the setup.sh bash script

You wil be asked about the project name. 

```bash
# Run 
./setup.sh
```

## SSH into the new VM

Visit https://console.cloud.google.com/compute/instances and click the `Connect SSH` button.

## Install docker

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y docker.io=19.03.8-0ubuntu1.20.04
```

## Add your user to the docker group

This is done not having to sudo each docker command. Note to put this change into effect you have to re-open the cloud shell.

```bash
sudo usermod -aG docker ${USER}
```
