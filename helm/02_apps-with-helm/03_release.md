## Upgrade a release

```bash
# Release the red application
helm install my-app ./color-viewer

# Visit the red application in the browser
http://<EXTERNAL-IP>/red

# Re-release 
helm upgrade my-app --set color=blue ./color-viewer

# Visit my-app in the browser
# Note this will not work
http://<EXTERNAL-IP>/red

# Visit my-app in the browser
http://<EXTERNAL-IP>/blue

# Show all releases, note there is only one release
helm ls

# Take a look at the history of my-app
helm history my-app

# Rollback to the previous version of my-app
helm rollback my-app 1

# Visit my-app in the browser
http://<EXTERNAL-IP>/red

# Visit my-app in the browser
# Note this will not work
http://<EXTERNAL-IP>/blue

# Cleanup
helm uninstall my-app
```
