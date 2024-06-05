# Build Applications

Build and push Go applications:

```bash
cd 00_apps/golang
make docker-push-all
```

These container images with tags will be created:

- `quay.io/kubermatic-labs/training-application:1.0.0-go`
- `quay.io/kubermatic-labs/training-application:1.0.1-go`
- `quay.io/kubermatic-labs/training-application:1.0.2-go`

<!-- TODO only one container should exist afterwards -->