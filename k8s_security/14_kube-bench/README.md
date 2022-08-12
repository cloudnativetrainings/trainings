# kubebench

kubectl apply -f 14_kube-bench/job.yaml
kubectl logs -f <KUBE_BENCH_POD>
kubectl logs -f <KUBE_BENCH_POD> | grep FAIL
