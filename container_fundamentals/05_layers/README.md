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

  What's about the sha of the image. 
  ```bash
  docker inspect debian:10.5 | grep Id
  ```

  You can also use these SHA ID to run the container. 
  ```bash
  docker run -it <VALUE-OF-SHA-ID>
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

Dive (https://github.com/wagoodman/dive) is a CLI tool to inspect the layers of an image.

* Install dive
  ```bash
  wget https://github.com/wagoodman/dive/releases/download/v0.9.2/dive_0.9.2_linux_amd64.deb
  sudo apt install ./dive_0.9.2_linux_amd64.deb
  ```

* Inspect an image via dive
  ```bash
  dive nginx:1.19.2
  ```

[Jump to Home](../README.md) | [Previous Training](../04_interact/README.md) | [Next Training](../06_build-images-interactive/README.md)
