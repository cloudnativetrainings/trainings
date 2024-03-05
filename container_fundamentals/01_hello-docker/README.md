# Hello Docker

In this training, you will start a Linux OS container and install a web server into it.

## Verify no web server is running on your VM

Visit your VM on port 80 via http in your browser.

>You can get the external IP of your VM via the command `make get-external-ip` in your home directory.

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

## Revisit the welcome page in your browser

Now you should see the welcome page of nginx.

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

# List running containers
podman ps

# List all containers
podman ps -a

# Remove the container
podman rm <Container-ID>
```
