# Shell vs exec form - PID1

In this training you will learn the difference between shell and exec form concerning PID1.

## Inspect the Dockerfile 

## Build the image

```bash
docker build -t entrypoint-vs-cmd-pid1:1.0.0 .
```

## Run a container from the image

```bash
docker run -it entrypoint-vs-cmd-pid1:1.0.0
```

Note that the process within the container has PID 1.

## Change the entrypoint to the following in the Dockerfile

```
ENTRYPOINT ps aux
```

## Build the image

```bash
docker build -t entrypoint-vs-cmd-pid1:2.0.0 .
```

## Run a container from the image

```bash
docker run -it entrypoint-vs-cmd-pid1:2.0.0
```

Note that the process within the container has not PID 1. So the started process will not receive lifecycle signals like SIGTERM or SIGKILL. This can lead to data loss of your application due to gracefull shutdown will not happen.
