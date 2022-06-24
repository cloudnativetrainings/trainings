export GOOGLE_CREDENTIALS=$(cat ~/key.json)

eval `ssh-agent`
ssh-add ~/.ssh/kkp_admin_training

sudo apt-get install -y uuid-runtime apache2-utils 

chmod +x ~/tmp/kubeone/kubeone
sudo cp ~/tmp/kubeone/kubeone /usr/local/bin

chmod +x ~/tmp/kkp/kubermatic-installer
sudo cp ~/tmp/kkp/kubermatic-installer /usr/local/bin

source <(kubectl completion bash)
