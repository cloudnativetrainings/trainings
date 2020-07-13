# Kubernetes Guestbook Example

Based on the Kubernetes tutorial this example will show how a multi-tier web application is built and deployed to a Kubernetes cluster. It consists of Redis as a database backend and a PHP guestbook. Redis will get a single-instance master to store the entries together with multiple replicated instances for reading. The guestbook will run on multiple frontend instances.

## Preparation

* Log into [https://console.cloud.google.com](https://console.cloud.google.com)
* Ensure started cluster
* Alternative run local cluster via *minikube* or *KinD*
* Create namespace `guestbook` with `kubectl create ns guestbook`
* Clone GitHub repository [https://github.com/loodse/k8s-exercises.git](https://github.com/loodse/k8s-exercises.git)
* You'll find this example at `./k8s-exercises/k8s/fundamentals/kubernetes_example`

## Contents

1. [Deploy the Redis Master](./01_deploy_redis_master.md)
2. [Deploy the Redis Slaves](./02_deploy_redis_slaves.md)
3. [Deploy the Guestbook Frontend](./03_deploy_guestbook.md)
4. [Scale Guestbook Frontend up and down](04_scale_guestbook.md)
