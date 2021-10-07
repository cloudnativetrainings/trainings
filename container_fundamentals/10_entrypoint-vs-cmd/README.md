# ENTRYPOINT vs CMD

In this training, you will learn the differences between ENTRYPOINT and CMD.

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
  ```docker
  FROM ubuntu:20.10
  ENTRYPOINT [ "echo" ]
  CMD [ "hello docker" ]
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

[Jump to Home](../README.md) | [Previous Training](../09_build-ignore/README.md) | [Next Training](../11_shell-vs-exec-form-variable-substitution/README.md)