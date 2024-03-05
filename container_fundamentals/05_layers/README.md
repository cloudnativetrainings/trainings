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

## Inspect the layers via docker inspect

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

## Inspect via dive

Dive <https://github.com/wagoodman/dive> is a CLI tool to inspect the layers of an image.

Inspect an image via dive

```bash
# Verify dive is installed properly
dive --version

# Inspect a specific nginx image
dive nginx:1.23.1
```

> Note that you can navigate the layers in dive via arrow up and down keys. Via the tab key you can dig deeper in the specific layer. You can exit dive via CTRL+C.

## Cleanup

```bash
# Remove all the containers
docker rm -f $(docker ps -qa)

#  Remove all the images
docker rmi -f $(docker images -qa)
```
