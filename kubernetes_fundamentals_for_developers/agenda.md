# Kubernetes Fundamentals for Developers

* [OK] Application Configuration via ConfigMaps
* [OK] Getting K8s Metainfo into your Application
* [OK] Calling the Kubernetes API from your Application
* [OK] Healthchecking your Application
* [OK] Graceful Shutdown of your Application
* [OK] Why Graceful Shutdown does not happen?
* [OK] Managing Resources of your Application
* [OK] Init Containers
* Debugging Containers
* Managing Secrets via Hashicorp Vault

* Providing custom Metrics from your Application
* Manage Logs of a legacy Application
* Troubleshooting
  * Why you should not deploy your Application via Pods?
  * Debugging Ingress Issues


# TODO 
* IP regex does not work => ip is not set in .trainingrc
  * the problem is probably there is no make goal dep
  * the env is evaluated before the kf setup is done
* dragons => make use of loki
