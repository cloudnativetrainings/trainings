# Layers

## Layers in docker image

Each Docker image references a list of read-only layers that represent 
filesystem differences. 

Layers are stacked on top of each other to form a base for a container's root 
filesystem. 

Pull `debian` image to your local system.
`docker pull debian`.

`docker history debian` shows you list of layers that `debian` image 
contains.

More Information you can find out with:
`docker inspect debian`

## Inspect the layers

More Information about an image you can find out with:
`docker inspect debian`

There you will also see how the image is build and e.g. which command will executed at the container startup.

`docker inspect debian | grep Cmd --after-context=10`

Or what user

`docker inspect debian | grep User --before-context=5`

What's about the sha of the image. 

`docker inspect debian | grep Id`


You can also use these to run the container:

`docker run -it sha256:0af60a5c6dd017d7023f6b6c71f3ffbb9beb2948d842bcb1ba36d597fb96e75a`
