# Interacting

In this training, you will learn how to interact with a container.

>Note that we are overwriting the CMD from the Dockerfile via `sh -c "while true; do $(echo date); sleep 1; done"`. This will be covered in a following training.

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

* Attach local standard input, output, and error streams to a running container using 
  ```bash
  docker attach my-busybox
  ```

* Cleanup
  ```bash
  docker rm -f my-busybox
  ```

## Starting an additional process in a container

* Start a container in detached mode
  ```bash
  docker run -it -d --name my-busybox busybox:1.32.0 sh -c "while true; do $(echo date); sleep 1; done"
  ```

* Start a new shell process inside the container
  ```bash
  docker exec -it my-busybox sh
  ```

* Take a look at the running processes inside the container. There are additional processes beside the process with the PID 1.
  ```bash
  ps aux
  ```

* Exit the container.
  ```bash
  exit
  ```

* Cleanup
  ```bash
  docker rm -f my-busybox
  ```

[Jump to Home](../README.md) | [Previous Training](../03_container-lifecycle/README.md) | [Next Training](../05_layers/README.md)