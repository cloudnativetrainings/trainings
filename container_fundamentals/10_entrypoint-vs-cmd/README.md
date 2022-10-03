# ENTRYPOINT vs CMD

In this training, you will learn the differences between ENTRYPOINT and CMD.

>Navigate to the folder `10_entrypoint-vs-cmd` from CLI, before you get started.

## Inspect the Dockerfile

```bash
cat Dockerfile
```

## Build and run the image

The executable is defined in the CMD.

```bash
docker build -t entrypoint-vs-cmd:1.0.0 .
docker run -it --rm --name entrypoint-vs-cmd entrypoint-vs-cmd:1.0.0
```

## Define the executable via ENTRYPOINT

* Adapt the Dockerfile like this

  ```bash
  cat << EOF | sudo tee Dockerfile
  FROM ubuntu:22.04
  ENTRYPOINT [ "echo" ]
  CMD [ "hello docker" ]
  EOF
  ```

* Build and run the image

  ```bash
  docker build -t entrypoint-vs-cmd:2.0.0 .
  docker run -it --rm --name entrypoint-vs-cmd entrypoint-vs-cmd:2.0.0
  ```

* Overwrite the params of the executable

  Now, you can overwrite CMD via adding the parameters at the end of docker run.

  ```bash
  docker run -it --rm --name entrypoint-vs-cmd entrypoint-vs-cmd:2.0.0 bonjour docker
  ```

* Overwrite the executable itself

  You can also overwrite the executable of the docker image. This comes in very handy on debugging containers which do not start properly.

  ```bash
  docker run -it --rm --name entrypoint-vs-cmd --entrypoint sleep entrypoint-vs-cmd:2.0.0 5
  ```

## Cleanup

* Remove all the images

  ```bash
  docker rmi -f $(docker images -qa)
  ```

[Jump to Home](../README.md) | [Previous Training](../09_build-ignore/README.md) | [Next Training](../11_shell-vs-exec-form-variable-substitution/README.md)
