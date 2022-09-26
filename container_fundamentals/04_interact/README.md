# Interacting

In this training, you will learn how to interact with a container.

>Note that we are overwriting the CMD from the Dockerfile via `sh -c "while true; do $(echo date); sleep 1; done"`. This will be covered in a following training.

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
