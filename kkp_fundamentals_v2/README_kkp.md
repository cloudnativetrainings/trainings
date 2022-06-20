

# storageclass
kubectl apply -f storageclass.yaml 

# installer
./kubermatic-installer deploy \
  --config kubermatic.yaml \
  --helm-values values.yaml 

## DNS entries

## cert-manager

base64 -w0 /home/hubert/Desktop/sva/installation/gcp/kubeone/hubert-sva-segfault-kubeconfig
kubectl apply -f seed.yaml

## DNS entry for nodeport-proxy

## service account
base64 -w0 /home/hubert/Desktop/sva/installation/gcp/kubeone/k1-cluster-provisioner-sa-key.json

kubectl apply -f preset.yaml

https://hubert.lab.kubermatic.io/

## print all config possibilities
./kubermatic-installer print > kubermatic.config.yaml
