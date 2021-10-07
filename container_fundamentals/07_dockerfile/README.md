# Dockerfile

In this training, you will create your own image and run it afterwards.

## Inspect the Dockerfile
```bash
cat Dockerfile
```

## Build the image
```bash
docker build -t my-image:1.0.0 .
```
>The instruction `-t my-image:1.0.0` defines the name and the version of the resulting image.

>The instrucition `.` tells the build process the location of the build context. 

## View the stored images
```bash
docker images
```

## Run a container from the image
```bash
docker run -it my-image:1.0.0
```

## Cleanup
Remove all the containers
```bash
docker rm -f $(docker ps -qa)
```

[Jump to Home](../README.md) | [Previous Training](../06_build-images-interactive/README.md) | [Next Training](../08_dockerfile_webserver/README.md)