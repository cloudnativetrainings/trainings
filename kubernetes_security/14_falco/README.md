
# Runtime Security with Falco

## Verify installation

```bash
systemctl status falco
```

## Configure Falco

Edit the Falco configuration file
```bash
vi /etc/falco/falco.yaml
```

Configure the `file_output` section to the following.
```yaml
file_output:
  enabled: true
  keep_alive: false
  filename: /var/log/falco.log
```

Restart Falco
```bash
systemctl restart falco
```

# Verify logging

```bash
# exec into the pod (and exit afterwards)
kubectl exec -it my-suboptimal-pod -- bash

# verify that a line like this got logged
cat /var/log/falco.log | grep 'Notice A shell was spawned in a container with an attached terminal'
```
