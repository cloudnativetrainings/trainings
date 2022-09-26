# Create a webserver image

In this training, we will create an image with an customized webserver.

>Navigate to the folder `08_dockerfile_webserver` from CLI, before you get started.

## Inspect the Dockerfile

```bash
cat Dockerfile
```

## Build the image

```bash
docker build -t my-webserver:1.0.0 .
```

>The instruction `-t my-webserver:1.0.0` defines the name and the version of the resulting image.
>The instrucition `.` tells the build process the location of the build context.

## Run a webserver container from the newly built image

```bash
docker run -it -d -p 80:80 my-webserver:1.0.0
```

Verify the output with curl command

```bash
curl localhost:80
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

[Jump to Home](../README.md) | [Previous Training](../07_dockerfile/README.md) | [Next Training](../09_build-ignore/README.md)
