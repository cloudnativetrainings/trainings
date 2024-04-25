
gcloud compute ssh worker-01
gcloud compute scp configs/10-bridge.conf \
                   configs/99-loopback.conf \
                   configs/containerd-config.toml \
                   configs/crictl.yaml \
                   configs/kube-proxy-config.yaml \
                   configs/kubelet-config.yaml \
                   services/containerd.service \
                   services/kube-proxy.service \
                   services/kubelet.service \
                   worker-0:

# TODO worker-0!!!!
gcloud compute scp secrets/worker-0.pem \
                   secrets/worker-0-key.pem \
                   secrets/worker-0.kubeconfig \
                   secrets/kube-proxy.kubeconfig \
                   secrets/ca.pem \
                   worker-0:

# copy .trainingrc file
gcloud compute scp ~/.node_trainingrc worker-0:~/.trainingrc

---

source .trainingrc

sudo apt-get update
sudo apt-get -y install socat conntrack ipset

swapoff -a
# TODO ensure swap is off also on reboot

