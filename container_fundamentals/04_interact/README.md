# Interacting

In this training you will learn how to interact wit a container.

Note that we are overwriting the ARGS from the Dockerfile via `sh -c "while true; do $(echo date); sleep 1; done"`. This will be covered in a following training.

## Foreground Containers

Start a container which puts out the current date each second
```bash
docker run -it --name my-busybox busybox:1.32.0 sh -c "while true; do $(echo date); sleep 1; done"
```

Note that you have to start the container with the flags `--interactive` and `--tty`.

To detach from the container press Ctrl+p followed by Ctrl+q. Note that the container is still running
```bash
docker ps
```

Re-attach to the container
```bash
docker attach my-busybox
```

To stop it, press Ctrl+c.

Note that the container is stopped.
```bash
docker ps
```

You cannot attach again to the container until it gets restarted.
```bash
docker attach my-busybox
```

Cleanup
```bash
docker rm my-busybox
```

## Detached Containers

```bash
docker run -it -d --name my-busybox busybox:1.32.0 sh -c "while true; do $(echo date); sleep 1; done"
```

It will start a container in detached mode using `-d` flag.

You can attach local standard input, output, and error streams to a running 
container using 
```bash
docker attach my-busybox
```

Cleanup
```bash
docker rm my-busybox
```

## Starting an additional process in a container

Start a container in detached mode
```bash
docker run -it -d --name my-busybox busybox:1.32.0 sh -c "while true; do $(echo date); sleep 1; done"
```

Start a new shell process in the container
```bash
docker exec -it my-busybox sh
```

Take a look at the running processes in the container. There are additional processes beside the process with the PID 1.
```bash
ps aux
```

Cleanup
```bash
docker rm -f my-busybox
```

## Check the container logs

Create a new container with name `test` from `busybox` image.
```bash
docker run -d --name my-busybox busybox:1.32.0 sh -c "while true; do $(echo date); sleep 1; done"
```

Check logs using 
```bash
docker logs my-busybox
```

You can get follow the logs using 
```bash
docker logs my-busybox --follow
```

Cleanup
```bash
docker rm -f my-busybox
```
