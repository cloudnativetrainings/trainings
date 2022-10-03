# Exec vs Sell form - PID1

In this training, you will learn the difference between exec and shell form concerning PID1.

>Navigate to the folder `12_shell-vs-exec-form-PID1` from CLI, before you get started.

## Inspect the Dockerfile

```bash
cat Dockerfile
```

> You can see the exec form of `ENTRYPOINT`

## Build the image

```bash
docker build -t shell-vs-exec-form-pid1:1.0.0 .
```

## Run a container from the image

```bash
docker run -it shell-vs-exec-form-pid1:1.0.0
```

>Note that the process `ps aux` within the container is PID 1.

## Change the entrypoint to the following in the Dockerfile

```docker
ENTRYPOINT ps aux

# or run the command below:
sed -i 's|\(ENTRYPOINT \).*|\1ps aux|' Dockerfile
```

> This is shell form of `ENTRYPOINT`

## Rebuild the image

```bash
docker build -t shell-vs-exec-form-pid1:2.0.0 .
```

## Run a container from the new image

```bash
docker run -it shell-vs-exec-form-pid1:2.0.0
```

>Note that the process `ps aux` within the container is not PID 1. Hence, the started process will not receive lifecycle signals like SIGTERM or SIGKILL. This can lead to data loss of your application since  the container will not exit cleanly.

## Cleanup

* Remove all the containers

  ```bash
  docker rm -f $(docker ps -qa)
  ```

* Remove all the images

  ```bash
  docker rmi -f $(docker images -qa)
  ```

[Jump to Home](../README.md) | [Previous Training](../11_shell-vs-exec-form-variable-substitution/README.md) | [Next Training](../13_caching/README.md)
