1. Ensure you are using the right Container Registry

2. Apply the yaml files in the k8s folder

3. Apply all yaml files in the 00_monitoring folder

4. Adapt the Prometheus ConfigMap to scrape 'my-app'. You have to reload the Prometheus configuration via 'curl -X POST http://<NODE-IP>:30001/-/reload' afterwards

5. Take a look at the metrics via the spy 'kubectl exec -it spy -- bash'. Curl the prometheus endpoint via 'curl my-app:8080/actuator/prometheus'

6. Ensure that there is a metric called 'my_counter'

7. Play around with PromQL

8. Create a Dashboard with Grafana

---

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

# mention label cardinality issues

# mention interceptors



