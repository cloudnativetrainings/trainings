# Host Level Security with AppArmor

## Verify installation

```bash
# check installation
systemctl status apparmor

# check apparmor is enabled
cat /sys/module/apparmor/parameters/enabled

# see status of apparmor - see all loaded profiles
aa-status

# inspect default profiles directory
ls -alh /etc/apparmor.d/
```

## Verify Pod is allowed to write files

```bash
kubectl exec my-suboptimal-pod -- touch /tmp/some.file
kubectl exec -it my-suboptimal-pod -- ls -alh /tmp
```

## Engage AppArmor

### Add AppArmor Profile

```bash
# inspect the apparmor profile
cat 11_apparmor/my-apparmor-profile

# copy the profile into the apparmor default profiles directory
cp 11_apparmor/my-apparmor-profile /etc/apparmor.d/

# restart apparmor
systemctl restart apparmor

# verify new profile got added
 aa-status | grep my-apparmor-profile
```

### Engage Profile in Pod

Enable the apparmor annotation in the file `pod.yaml`
```yaml
...
metadata:
  name: my-suboptimal-pod
  annotations: # <= uncomment this line
    container.apparmor.security.beta.kubernetes.io/my-ubuntu: localhost/my-apparmor-profile # <= uncomment this line
...
```

```bash
# re-apply the pod
kubectl apply -f pod.yaml --force

# try to write the file again - you should get an error
kubectl exec my-suboptimal-pod -- touch /tmp/some.file
```
