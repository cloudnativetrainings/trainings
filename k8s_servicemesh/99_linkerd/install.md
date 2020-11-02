
https://linkerd.io/2/getting-started/

curl -sL https://run.linkerd.io/install | sh


export PATH=$PATH:$HOME/.linkerd2/bin

linkerd version


linkerd check --pre

linkerd install | kubectl apply -f -

linkerd dashboard &

linkerd uninstall | kubectl apply -f -
