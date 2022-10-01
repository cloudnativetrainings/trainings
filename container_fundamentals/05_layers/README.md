# Layers

## Layers in docker image

Each Docker image references a list of read-only layers that represent filesystem differences.

Layers are stacked on top of each other to form a base for a container's root filesystem.

* Pull `debian` image to your local system.

  ```bash
  docker pull debian:10.5
  ```

* Show image history

  ```bash
  docker history debian:10.5
  ```

  >shows you list of layers that `debian` image contains.

## Inspect the layers

* More Information about an image you can find out with `inspect`:

  ```bash
  docker inspect debian:10.5
  ```

* There you will also see how the image is build and e.g. which command will executed at the container startup.

  ```bash
  docker inspect debian:10.5 | grep Cmd --after-context=10
  ```

  Or what user

  ```bash
  docker inspect debian:10.5 | grep User --before-context=5
  ```

  What is the SHA of the image.

  ```bash
  docker inspect debian:10.5 | grep Id
  ```

  You can also use these SHA ID to run the container.

  ```bash
  docker run -it $(docker inspect debian:10.5 | jq -r .[].Id)
  ```

* Cleanup:
  Remove all the containers

  ```bash
  docker rm -f $(docker ps -qa)
  ```

  Remove all the images

  ```bash
  docker rmi -f $(docker images -qa)
  ```

## Inspect via dive

Dive <https://github.com/wagoodman/dive> is a CLI tool to inspect the layers of an image.

Inspect an image via dive

```bash
dive nginx:1.23.1
```

## Extract the container layers via skopeo

Skopeo <https://github.com/containers/skopeo> is a command line utility that performs various operations on container images and image repositories.

Extract container layers to your filesystem

```bash
# Copy/extract nginx image to /tmp directory
skopeo copy docker://nginx:1.23.1 dir://tmp/nginx-image-layers

# Check what files are there
ls -l /tmp/nginx-image-layers

# Check the file type, it is a gzip compressed data
file /tmp/nginx-image-layers/31b3f1ad4ce1f369084d0f959813c51df0ca17d9877d5ee88c2db6ff88341430

# Check the contents of the file via tar
tar ztvf /tmp/nginx-image-layers/31b3f1ad4ce1f369084d0f959813c51df0ca17d9877d5ee88c2db6ff88341430
```

[Jump to Home](../README.md) | [Previous Training](../04_interact/README.md) | [Next Training](../06_build-images-interactive/README.md)
