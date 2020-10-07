# Hello Docker

In this training you will start a container and install a web server into it.

## Run an ubuntu container
```bash
docker run -it -p 80:80 ubuntu:20.10
```

## Install a web server
```bash
apt update && apt install -y apache2
```

## Run the web server

```bash
apache2ctl -DFOREGROUND
```

## Visit the welcome page in your browser 

To get the external IP you can visit https://console.cloud.google.com/networking/addresses/.

## Stop the process in the Docker container

Press CTRL+C keys.

## Exit the container

```bash
exit
```

## Take a look at the running Docker containers

```bash
docker ps
```

## The Container is already in state `EXITED`. To see the Container do the following

```bash
docker ps -a
```

## Cleanup

```bash
docker rm <TAB>
```