# Benchmarking via kubebench


```bash
# inspect the kubebench job
cat 14_kube-bench/job.yaml

# run kubebench
kubectl apply -f 14_kube-bench/job.yaml

# inspect the logs of kubebench 
kubectl logs <KUBE_BENCH_POD>
```
