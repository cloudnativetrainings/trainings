# Interacting

In this training, you will learn how to interact with a container.

>Note that we are overwriting the CMD from the Dockerfile via `sh -c "while true; do $(echo date); sleep 1; done"`. This will be covered in a following training.

## Attach to the process with PID 1 in the container

```bash
# Start a Container in detached mode
docker run -it --rm -d --name my-busybox busybox:1.32.0 sh -c "while true; do $(echo date); sleep 1; done"

# start a new shell process inside the container
docker attach my-busybox

# exit the container via CTRL+C. Note the container got stopped and removed afterwards.
```


## Spawn a new process in the container and attach to it

```bash
# Start a Container in detached mode
docker run -it --rm -d --name my-busybox busybox:1.32.0 sh -c "while true; do $(echo date); sleep 1; done"

# start a new shell process inside the container
docker exec -it my-busybox sh

# take a look at the running processes inside the container. There are additional processes beside the process with the PID 1.
ps aux

# exit the container
exit
```

## Cleanup

```bash
docker rm -f my-busybox
```
