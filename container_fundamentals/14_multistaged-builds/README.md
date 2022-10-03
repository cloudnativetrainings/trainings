# Multistaged builds

In this training, you will learn how to build your applications.

>Navigate to the folder `14_multistaged-builds` from CLI, before you get started.

## Inspect the Dockerfile and the main.go file

```bash
cat Dockerfile
cat main.go
```

## Build and run the application

```bash
docker build -t go:1.0.0 . 
docker run -it go:1.0.0
```

## Make use of multistaged builds

Now we will create the same application with a multistaged build. This will decrease the image size and will shrink the images attack vector.

Adapt the Dockerfile to the following

```docker
# builder image
FROM golang:1.19.1-alpine3.16 as builder
RUN mkdir /build
ADD main.go /build/
WORKDIR /build
RUN go mod init myapp && CGO_ENABLED=0 GOOS=linux go build -o main .

# run image
FROM alpine:3.16
RUN mkdir /app
WORKDIR /app
COPY --from=builder /build/main .
ENTRYPOINT [ "./main" ]
```

## Rebuild and run the application

```bash
docker build -t go:2.0.0 . 
docker run -it go:2.0.0
```

## Compare the size of the images

```bash
docker image ls go
```

## Cleanup

* Remove all the containers

  ```bash
  docker rm -f $(docker ps -qa)
  ```

* Remove all the images

  ```bash
  docker rmi -f $(docker images -qa)
  ```

[Jump to Home](../README.md) | [Previous Training](../13_caching/README.md) | [Next Training](../15_logs/README.md)
