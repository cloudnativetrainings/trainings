# Doing a customized release

```bash
# Release with a custom values inline
helm install green --set color=green ./color-viewer

# Release with a cusotm values.yaml file
helm install magenta ./color-viewer -f my-values.yaml 

# Visit the green application in the browser
http://<EXTERNAL-IP>/green

# Visit the magenta application in the browser
http://<EXTERNAL-IP>/magenta

# Show all installed charts
helm ls

# Show kubernetes resources
kubectl get all

# Uninstall the releases
helm uninstall green magenta
```
