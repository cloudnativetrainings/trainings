
# apply monitoring

# apply k8s

# add service to prometheus config

# update prometheus
curl -X POST http://localhost:9090/-/reload
curl -X POST http://34.89.199.229:30001/-/reload

# verify metrics
kubectl exec -it spy -- bash
curl my-app:8080/actuator/prometheus

# create graphs
sum (kubelet_volume_stats_used_bytes) by (namespace, persistentvolumeclaim) / (sum(kubelet_volume_stats_capacity_bytes) by (namespace, persistentvolumeclaim) / 100)

# recording rules
  recording.rules: |-
    groups:
      - name: loodse-training
        rules:
          - record: pvc:usage:percent
            expr: sum (kubelet_volume_stats_used_bytes) by (namespace, persistentvolumeclaim) / (sum(kubelet_volume_stats_capacity_bytes) by (namespace, persistentvolumeclaim) / 100)

# predict linear
predict_linear(pvc:usage:percent[1d], 7*24*3600) > 90            

# metric types
With histograms, quantiles are calculated on the Prometheus server. With summaries, they are calculated on the application server



