# Build Applications

## Java

Build and push Java application:

```bash
cd 00_apps/java
make docker-push-all
```

These container images with tags will be created:

- `quay.io/kubermatic-labs/kad-training:1.0.0-java`
- `quay.io/kubermatic-labs/kad-training:1.0.1-java`
- `quay.io/kubermatic-labs/kad-training:1.0.2-java`

## Golang

Build and push Go applications:

```bash
cd 00_apps/golang
make docker-push-all
```

These container images with tags will be created:

- `quay.io/kubermatic-labs/kad-training:1.0.0-go`
- `quay.io/kubermatic-labs/kad-training:1.0.1-go`
- `quay.io/kubermatic-labs/kad-training:1.0.2-go`
