# Setup Cluster

* Change into k8s_fundamental directory and run the script to initialize GKE cluster.
  
  ```bash
  $ cd k8s_fundamentals
  00_setup/setup_cluster.sh
  ```
  >Provide project details against  `INPUT: Type PROJECT_NAME (student-XX-project):`

  >If execution error related to GKE cluster version is encountered, then run `gcloud container get-server-config` to find latest Stable release to adjust the value of `--cluster-version` parameter in the `setup.sh` script
 
* Let's do quick verification
  ```bash
  kubectl cluster-info
  kubectl get nodes
  ```

[Jump to Home](../README.md) | [Next Training](../01_hello-k8s/README.md)
