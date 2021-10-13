# Setup Cluster

* Run the script to initialize GKE cluster.
  >Before executing the script, run `gcloud container get-server-config` to find latest Stable release.
  ```bash
  00_setup/setup_cluster.sh
  ```
  >Provide project details against  `INPUT: Type PROJECT_NAME (student-XX-project):`

  >Provide GKE cluster version details against  `INPUT: Type CLUSTER_VERSION (1.xx.yy-gke.zzzz):`

* Connect using below command
  ```bash
  gcloud container clusters get-credentials training-kf --zone europe-west3-a
  ```

* Let's do quick verification
  ```bash
  kubectl cluster-info
  kubectl get nodes
  ```

[Jump to Home](../README.md)
