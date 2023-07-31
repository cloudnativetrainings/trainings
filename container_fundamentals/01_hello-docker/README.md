# Hello Docker

In this training, you will start a Linux OS container and install a web server into it.

## Run an Ubuntu container

```bash
docker run -it -p 80:80 ubuntu:22.04
```

## Install a web server

```bash
apt update && apt install -y nginx
```

## Run the web server

```bash
/etc/init.d/nginx start
```

## Visit the welcome page in your browser

# TODO make get-external-ip

## Exit the container

```bash
exit
```

## Take a look at the running Docker containers

```bash
docker ps
```

## The Container is already in state `EXITED`. To see the Container, do the following

```bash
docker ps -a
```

## Cleanup

```bash
docker rm <Container-ID>
```

## What about Podman?

Just try the same commands with changing `docker` to `podman`.

```bash
# Run the container and curl to example.org
podman run -it docker.io/curlimages/curl http://example.org

# List containers
podman ps

# List all containers
podman ps -a

# Remove the container
podman rm <Container-ID>
```
