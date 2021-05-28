# Kubermatic Presets

To add the credentials in the Kubermatic UI as presets, encode it as base64 and copy it:
```bash
base64  -w 0 credentials.json
```

Then create a file `kubermatic-setup-file/kubermatic.presets.yaml` based on your [Kubermatic Docs > Advanced > Presets](https://docs.kubermatic.com/kubermatic/master/advanced/presets/)

Afterwards apply the file:
```bash
kubectl -n kubermatic -f kubermatic-setup-file/kubermatic.presets.yaml
```

Now you will be able to see a selection menu of the configured presets on the next cluster you will create, try it out!
