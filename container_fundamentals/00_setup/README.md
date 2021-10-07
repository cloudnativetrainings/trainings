# Provision VM with docker installation

## Run the setup.sh bash script
* You will be asked to enter the project name. 
  ```bash
  00_setup/setup.sh
  ```

## SSH into the new VM

Visit https://console.cloud.google.com/compute/instances and click the `Connect SSH` button.

## Install docker

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y docker.io
```

## Add your user to the docker group

Do this to avoid use of `sudo` for each docker command. Note to put this change into effect, if you have to re-open the cloud shell.

```bash
sudo usermod -aG docker $USER
```

[Jump to Home](../README.md) 