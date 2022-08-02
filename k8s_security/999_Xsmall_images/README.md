
# size of ubuntu

crictl pull debian
crictl image ls | grep debian

# distroless containers

crictl pull gcr.io/distroless/static
crictl image ls | grep distroless

kubectl run -it --rm distroless --image gcr.io/distroless/static --restart Never -- echo hello
kubectl run -it --rm distroless --image gcr.io/distroless/static --restart Never -- ls -alh
kubectl run -it --rm distroless --image gcr.io/distroless/static --restart Never -- /bin/sh

# size of alpine

crictl pull alpine
crictl image ls | grep alpine
