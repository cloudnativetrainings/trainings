# Add an AWS provider to datacenter `europe-west`

As demonstrated in the chapter before with GCP, we want to add an AWS provider to the datacenter, as specified in the [Kubermatic Docs > Concepts > Seed CRD documentation](https://docs.kubermatic.com/kubermatic/master/concepts/seeds/#example-seed).


To add a new datacenter we need to extend the `spec.datacenters.YOUR-SEED-DATACENTER.spec.LIST_OF_PROVIDERS` field:

Modify the `datacenter.yaml` and add the datacenter config ([Datacenter refence doc](https://docs.loodse.com/kubermatic/v2.12/concepts/datacenters/))

```bash
vim kkp-setup/datacenters.yaml
```
```yaml
apiVersion: kubermatic.k8s.io/v1
kind: Seed
metadata:
  name: europe-west
  namespace: kubermatic
spec:
  # ....
  datacenters:
    #==================================
    #============== GCP ===============
    #==================================
    gce-eu-west-4:
      #... 
    #==================================   <<<<< add for AWS               
    #============== AWS ===============                
    #==================================
    aws-eu-central-1a:
      country: DE
      location: EU Central - Frankfurt
      spec:
        aws:
          region: eu-central-1
```
Update the seed spec, with your favorite editor or just use `vim`: `vim kkp-setup/seed.europ-west.yaml`.

After the changes have been done, apply it to your Kubermatic **master** cluster:
```bash
kubectl apply -f kkp-setup/seed.europ-west.yaml
```

## Create AWS cluster

Now you can try to add an AWS cluster to your Kubermatic project:
- [Kubermatic Docs > Tutorials > Create Cluster](https://docs.kubermatic.com/kubermatic/master/tutorials/03-create-cluster/)

For the purpose of this training you will get some access keys from your trainer:
 
```
cat aws/.access_keys
```

## Delete Cluster
For the cluster deletion, you have two options:
1. Trough the UI dashboard: [Kubermatic Docs > Tutorials > Upgrade Cluster](https://docs.kubermatic.com/kubermatic/master/tutorials/04-upgrade-cluster/)
2. By deleting the `cluster` object trough the CLI:
  - Execute `kubectl delete cluster [cluster-id]`
