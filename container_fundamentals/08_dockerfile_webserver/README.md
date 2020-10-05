# Create a webserver image

In this training we will create an image with an customized webserver.

## Inspect the Dockerfile

## Build the image

```bash
docker build -t my-webserver:1.0.0 .
```

## Run a container from the image

```bash
docker run -it -d -p 80:80 my-webserver:1.0.0
```

Verify the output with curl:
```bash
curl localhost:8080
```

## Cleanup

```bash
docker rm -f $(docker ps -qa)
```
