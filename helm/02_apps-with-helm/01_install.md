# Doing a release

```bash
# Show all releases
helm ls

# Release with its default values
helm install red ./color-viewer

# Visit the red application in the browser
http://<EXTERNAL-IP>/red

# Show all releases
helm ls

# Show kubernetes resources
kubectl get all

# Uninstall the release
helm uninstall red
```
