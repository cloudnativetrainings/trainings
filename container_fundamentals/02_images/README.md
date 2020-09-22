# Images

In this training you will learn how to manage images.

## Search for an image

```bash
docker search nginx
```

## Download an image

You can pull an image from docker hub (default registry for docker images) to your local machine. Afterwards you can create containers of it.

```bash
docker pull nginx:1.19.2
```

## List local images

```bash
docker images
```

## Removing a local image

Lets start a container
```bash
docker run -d nginx:1.19.2
```

Try to remove the local image
```bash
docker rmi nginx:1.19.2
```
This will not work out due to the image is currently in use

Remove all running containers
```bash
docker rm -f $(docker ps -qa)
```
The inline command `docker ps -qa` returns the container id of all containers.

Try again to remove the image
```bash
docker rmi nginx:1.19.2
```

## Cleanup

```bash
docker rm pf $(docker ps -qa)
```
