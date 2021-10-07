# Create a webserver image

In this training, we will create an image with an customized webserver.

## Inspect the Dockerfile
```bash
cat Dockerfile
```

## Build the image
```bash
docker build -t my-webserver:1.0.0 .
```

## Run a container from the image
```bash
docker run -it -d -p 80:80 my-webserver:1.0.0
```

Verify the output with curl command
```bash
curl localhost:80
```

## Cleanup
Remove all the containers
```bash
docker rm -f $(docker ps -qa)
```

[Jump to Home](../README.md) | [Previous Training](../07_dockerfile/README.md) | [Next Training](../09_build-ignore/README.md)