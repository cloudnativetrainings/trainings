# Kubernetes Fundamentals

**Pre-requisites:**

>If you do not have Google Cloud Account, instead you are working on your local machine then you can simply skip #1 and #4 steps. Before you get started, please make sure that you have [Minikube installation](https://minikube.sigs.k8s.io/docs/start/) on your local machine.

1. Navigate and login to [Google Cloud Shell](https://ssh.cloud.google.com ) via web browser. 

2. Clone the Kubermatic trainings git repository:
    ```bash
    git clone https://github.com/kubermatic-labs/trainings.git
    ```

3. Navigate to Kubernetes Fundamentals training folder to get started
    ```bash  
    cd trainings/k8s_fundamentals/
    ```

4. [Setup](00_setup/README.md) - the GKE cluster for training.
   
**Hands-On:**

1. [Hello k8s](01_hello-k8s/README.md)
2. [Pods](02_pods/README.md)
3. [Commands and Args](03_commands-and-args/README.md)
4. [Multi-Container Pods](04_multi-container-pods/README.md)
5. [Replicasets](05_replicasets/README.md)
6. [Deployments](06_deployments/README.md)
7. [Revision History](07_revision-history/README.md)
8. [Services](08_services/README.md)
9. [Configmaps](09_configmaps/README.md)
10. [Secrets](10_secrets/README.md)
11. [Static Persistence](11_persistence-static/README.md)
12. [Dynamic Persistence](12_persistence-dynamic/README.md)
13. [Persistence Using Volumes](13_persistence-use-volume/README.md)
14. [StatefulSets](14_statefulsets/README.md)
15. [Horizontal Pod Autoscaler](15_hpas/README.md)
16. [DaemonSets](16_daemonsets/README.md)
17. [Jobs](17_jobs/README.md)
18. [Cron Jobs](18_cronjobs/README.md)
19. [Node Selector](19_scheduling-node-selector/README.md)
20. [Node Affinity](20_scheduling-affinity/README.md)
21. [Taints and Tolerations](21_scheduling-taints-and-tolerations/README.md)
22. [Ingress](22_ingress/README.md)
23. [Cordon](23_cordon/README.md)
24. [Drain](24_drain/README.md)
25. [Authentication](25_authentication/README.md)
26. [Authorization](26_authorization/README.md)
27. [Network Policies](27_networkpolicies/README.md)
28. [Helm](28_helm/README.md)
29. [Prometheus](29_prometheus/README.md)

[TearDown Setup](99_teardown/README.md) - Optional, for the GKE training cluster cleanup. 

[Back to Main](../README.md)