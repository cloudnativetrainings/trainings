# Google DNS
https://github.com/kubermatic-labs/temp-training/blob/master/gce/21_apiVersion: kubeone.io/v1beta1
kind: KubeOneCluster
versions:
  kubernetes: '1.23.7'
cloudProvider:
  gce: {}
  cloudConfig: |
    [global]
    regional = true
setup_kubermatic_dns.md

https://docs.kubermatic.com/kubeone/v1.4/tutorials/creating_clusters/

https://github.com/kubermatic/kubeone/tree/master/examples/terraform/gce