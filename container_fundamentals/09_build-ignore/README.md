# Build Ignore

In this training, you will learn how to exclude files from the resulting image.

## Build the image
```bash
docker build -t ignore:1.0.0 .
```

## Run the image
```bash
docker run -it ignore:1.0.0
```
>Take a look of the output of the container. All files are in the resulting container.

## Exclude files from the build

* Create a .dockerignore file
  Create a file called `.dockerignore` with the following content
  ```
  passwords.txt
  some-large-image.jpg
  ```

* Build the image
  ```bash
  docker build -t ignore:2.0.0 .
  ```

* Run the image
  ```bash
  docker run -it ignore:2.0.0
  ```
  >Notice the output of the container the files defined in the `.dockerignore` file are not included in the resulting image / container. Furthermore, this speeds up the build process due to those files will not get sent to the docker engine.

## Cleanup
Remove all the containers
```bash
docker rm -f $(docker ps -qa)
```

[Jump to Home](../README.md) | [Previous Training](../08_dockerfile_webserver/README.md) | [Next Training](../10_entrypoint-vs-cmd/README.md)