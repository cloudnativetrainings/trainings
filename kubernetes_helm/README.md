# Kubernetes Helm

## Pre-requisites

1. Navigate and login to [Google Cloud Shell](https://ssh.cloud.google.com ) via web browser. 

2. Configure some settings:
```bash
echo "-w \"\\n\"" > $HOME/.curlrc

cat <<EOT > $HOME/.vimrc
set expandtab
set tabstop=2
set shiftwidth=2
EOT

mkdir $HOME/.cloudshell && touch $HOME/.cloudshell/no-apt-get-warning

sudo apt-get update && sudo apt-get -y install tree bat
```

3. Create `.customize_environment` file to make sure tree and batcat will always be installed with new Cloud Shell instances
```bash
cat <<EOF > $HOME/.customize_environment
#!/bin/bash

apt-get update
apt-get -y install tree bat
EOF
```

4. Clone the Kubermatic trainings git repository:
```bash
git clone https://github.com/cloudnativetrainings/trainings.git
```

5. Navigate to Kubernetes Helm training folder to get started
```bash  
cd trainings/kubernetes_helm/
```

6. [Setup](00_setup/README.md) - the GKE cluster for training.
