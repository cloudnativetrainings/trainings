https://github.com/kubermatic/kubermatic/tree/master/addons

https://hub.docker.com/repository/docker/ueber/kkp-addons

https://docs.kubermatic.com/kubermatic/master/guides/addons/

https://hubert.lab.kubermatic.io/projects/v4hdmtjp7q/clusters/tfvnkg9l8v
https://hubert.lab.kubermatic.io/api/v2/projects/v4hdmtjp7q/clusters/tfvnkg9l8v/dashboard/proxy/#/overview?namespace=default


# custom addon

docker build -t ueber/kkp-addons:v2.18.1-hust .
docker push ueber/kkp-addons:v2.18.1-hust

adapt kubermatic.yaml
```yaml
  userCluster:
    addons:
      kubernetes:
        dockerRepository: docker.io/ueber/kkp-addons
        dockerTagSuffix: "hust"

  api:
    accessibleAddons:
      - cluster-autoscaler
      - node-exporter
      - kube-state-metrics
      - multus
      - hust-addon
```        

kubectl apply -f kubermatic.yaml

kubectl describe pod kubermatic-seed-controller-manager-57f4458d65-nsfd9
kubectl exec -it kubermatic-seed-controller-manager-57f4458d65-nsfd9 -- sh
ls -alh /opt/addons/kubernetes

