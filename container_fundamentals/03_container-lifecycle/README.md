# Container Lifecycle

In this training, you will learn about the lifecycle of a container.

## Create a container

```bash
docker run -d --name my-nginx nginx:1.23.1
```

>The image is searched locally if not found, then it will be downloaded first from Docker Hub. After that a container will be started.

## Inspect state of the container

Inspect the State of container

```bash
docker inspect my-nginx | jq '.[].State'
```

## Foreground Containers

* Start a container which prints the current date every second on the console

```bash
docker run -it --name my-busybox busybox:1.32.0 sh -c "while true; do $(echo date); sleep 1; done"
```

>Note that you have to start the container with the flags `--interactive` or `-i` and `--tty` or `-t`  i.e. together `-it`.

* To detach from the container, press Ctrl+p followed by Ctrl+q. Verify the status of the container.

```bash
docker ps -a
```

>Note that the container is still running.

* Re-attach to the container

```bash
docker attach my-busybox
```

* To stop it, press Ctrl+c. Verify the status of the container.

```bash
docker ps -a
```

>Note that the container is stopped with `EXITED` status.

* You cannot attach again to the container until it gets restarted.

```bash
docker attach my-busybox
```

* Cleanup

```bash
docker rm -f my-busybox
```

## Detached Containers

* Start a container which prints the current date every second on the console

```bash
docker run -it -d --name my-busybox busybox:1.32.0 sh -c "while true; do $(echo date); sleep 1; done"
```

>It will start a container in detached mode using `-d` flag.

* Attach local standard input, output, and error streams to a running container

```bash
docker attach my-busybox
```

* Cleanup

```bash
docker rm -f my-busybox
```

## Stop a running container

```bash
docker stop my-nginx
```

>Stop the started container. The main process inside the container will receive `SIGTERM`, and after a grace period, `SIGKILL`.

Inspect the ExitCode

```bash
docker inspect my-nginx | jq '.[].State'
```

## Restart a stopped container

```bash
docker restart my-nginx
```

## Kill a container

If you have e.g. an hanging container, it's possible to send the `SIGKILL` signal directly. Try

```bash
docker kill my-nginx
```

Inspect the ExitCode

```bash
docker inspect my-nginx | jq '.[].State'
```

The container is still startable

```bash
docker restart my-nginx
```

## Remove a container

```bash
docker rm my-nginx
```

>Note that the container has to be stopped before it can be removed. You can also use the `--force` or `-f` flag.

```bash
docker rm -f my-nginx
```

The container cannot be started anymore.

```bash
docker restart my-nginx
```

## Using the container id

Start some containers

```bash
docker run -d nginx:1.23.1
docker run -d nginx:1.23.1
docker run -d nginx:1.23.1
```

List all running containers

```bash
docker ps
```

>Note that the containers got some randomly generated names. You can either use these names or you can the first letters of the container id to define the container in the commands.

## Cleanup

Remove all the containers

```bash
docker rm -f $(docker ps -qa)
```
