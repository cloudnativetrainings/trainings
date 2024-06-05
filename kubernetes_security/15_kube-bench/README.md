# Benchmarking via kubebench

```bash
# inspect the kubebench job
cat 15_kube-bench/job.yaml

# run kubebench
kubectl apply -f 15_kube-bench/job.yaml

# inspect the logs of kubebench
kubectl logs <KUBE_BENCH_POD>
```
