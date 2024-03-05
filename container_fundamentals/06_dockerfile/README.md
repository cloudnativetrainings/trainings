# Dockerfile

In this training, you will create your own image and run it afterwards.

>Navigate to the folder `06_dockerfile` from CLI, before you get started.

## Inspect the Dockerfile

```bash
cat Dockerfile
```

## Build the image

```bash
docker build -t my-image:1.0.0  .
```

>The instruction `-t my-image:1.0.0` defines the name and the version of the resulting image.
>The instrucition `.` tells the build process the location of the build context.

## View the newly built images

```bash
docker images
```

## Run a container from the image

```bash
docker run -it my-image:1.0.0
```

>Type Ctrl+c to exit from container.

## Cleanup

```bash
# Remove all the containers
docker rm -f $(docker ps -qa)

#  Remove all the images
docker rmi -f $(docker images -qa)
```
