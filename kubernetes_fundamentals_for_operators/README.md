
# setup
makefile setup
source ~/.trainingrc

# tmux
disable in google cloud shell

# after tmux
source ~/.trainingrc

# after masters are ready
kubectl cluster-info \
  --kubeconfig admin.kubeconfig

  # TODO
  check if configs and services are all used and copied to proper master or worker 

why do we need one public ip for a master node? => no LB probably
