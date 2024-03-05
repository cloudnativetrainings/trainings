# Build Ignore

In this training, you will learn how to exclude files from the resulting image.

>Navigate to the folder `08_build-ignore` from CLI, before you get started.

## Inspect the Dockerfile

```bash
cat Dockerfile
```

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

* Create a .dockerignore file with the following content

```txt
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

>Notice the output of the container, the files defined in the `.dockerignore` file are not included in the resulting image / container. Furthermore, this speeds up the build process as those files will not get sent to the docker engine.

## Cleanup

```bash
# Remove all the containers
docker rm -f $(docker ps -qa)

#  Remove all the images
docker rmi -f $(docker images -qa)
```
