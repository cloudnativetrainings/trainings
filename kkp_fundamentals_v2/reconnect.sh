export GOOGLE_CREDENTIALS=$(cat ~/secrets/key.json)
KUBEONE_VERSION=1.4.4
KKP_VERSION=2.20.2

eval `ssh-agent`
ssh-add ~/secrets/kkp_admin_training

sudo apt-get install -y uuid-runtime apache2-utils 
sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
sudo chmod a+x /usr/local/bin/yq

sudo cp ~/.tmp/kubeone-$KUBEONE_VERSION/kubeone /usr/local/bin

sudo cp ~/.tmp/kubermatic-ce-$KKP_VERSION/kubermatic-installer /usr/local/bin

FILE=~/.tmp/kubermatic-ce-$KKP_VERSION/kubermatic-installer
if test -f "$FILE"; then
    sudo cp ~/.tmp/kubermatic-ce-$KKP_VERSION/kubermatic-installer /usr/local/bin
fi

export KUBECONFIG=~/kubeone/kkp-admin-kubeconfig
