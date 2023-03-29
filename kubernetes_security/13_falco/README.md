
# Runtime Security with Falco

## Verify installation

```bash
# fix falco installation (falco changed the installation process completely and the current version 0.34.1 does not work)
apt remove falco
apt install falco=0.33.1
```

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
