# Build Applications

Build and push Go applications:

```bash
cd 00_apps/golang
make docker-push-all
```

These container images with tags will be created:

- `quay.io/kubermatic-labs/training-application:2.0.0-distroless`
- `quay.io/kubermatic-labs/training-application:2.0.0-A`
- `quay.io/kubermatic-labs/training-application:2.0.0-B`
- `quay.io/kubermatic-labs/training-application:2.0.0`
