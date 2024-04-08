# Kubernetes Fundamentals

## Setup

1. Navigate and login to [Google Cloud Shell](https://ssh.cloud.google.com ) via web browser. 

2. Clone the Kubermatic trainings git repository:

```bash
git clone https://github.com/kubermatic-labs/trainings.git
```

3. Navigate to Kubernetes Fundamentals training folder to get started

```bash
cd trainings/kubernetes_fundamentals/
```

4. Create the cluster
   
```bash
make create-cluster
```

5. Verify everything is working
```bash
kubectl cluster-info
kubectl get nodes
```

## Teardown

```bash
make teardown-cluster
```
