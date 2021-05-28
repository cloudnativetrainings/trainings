# Helm
To install some basic artifacts into our cluster we use helm:

## Install [Helm `v3`](https://helm.sh/docs/intro/install/) to your machine

```bash
curl -L https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
### ensure in cloud shell to be constant
mkdir ~/bin && cp `which helm` ~/bin/

### verify helm3
helm version
### add bash completion
echo 'source <(helm completion bash)' >> ~/.bashrc && bash
```
