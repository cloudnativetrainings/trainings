# Mismatch with official Agenda

https://www.cloud-native.com/trainings/kubernetes-fundamentals-for-developers/

* Providing custom Metrics from your Application
* Manage Logs of a legacy Application
* Troubleshooting
  * Why you should not deploy your Application via Pods? => is in the KF4O
  * Debugging Ingress Issues

# Fix Loki
and use it in the labs, eg on graceful_shutdown_dragons

# Installation of ingress-nginx
does not work if the same cluster like in Kubernetes Fundamentals is used and teardown was not done properly => namespace already exists, helm install fail
