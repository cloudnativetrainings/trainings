
# copy secrets
sudo install -o root -m 0644 ${HOSTNAME}.pem /var/lib/kubelet/kubelet.pem
sudo install -o root -m 0600 ${HOSTNAME}-key.pem /var/lib/kubelet/kubelet-key.pem
sudo install -o root -m 0600 ${HOSTNAME}.kubeconfig /var/lib/kubelet/kubeconfig
sudo install -D -o root -m 0644 ca.pem /var/lib/kubelet/

# create kubelet config file
export POD_CIDR=$(curl -s -H "Metadata-Flavor: Google" \
  http://metadata.google.internal/computeMetadata/v1/instance/attributes/pod-cidr)
envsubst < kubelet-config.yaml > kubelet-config.yaml.subst
sudo install -D -o root -m 0644 kubelet-config.yaml.subst /var/lib/kubelet/kubelet-config.yaml

# create kubelet service file
sudo install -o root -m 0644 kubelet.service /etc/systemd/system/kubelet.service


---

# If the folder `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
# sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring
# TODO version kubernetes 1.28!!! => env

# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly
# TODO version kubernetes 1.28!!! => env

sudo apt-get update
sudo apt-get install -y kubelet

# TODO do this instead!!!
"https://storage.googleapis.com/kubernetes-release/release/v$KUBERNETES_VERSION/bin/linux/amd64/kubectl"
sudo install -o root -m 0755 kube{ctl,-apiserver,-controller-manager,-scheduler} /usr/local/bin/

# also fix bin path in kubelet.service to /usr/local/bin....


---


# start kubelet service
sudo systemctl daemon-reload
sudo systemctl enable kubelet
sudo systemctl start kubelet
# TODO Kubernetes version