# Images Interactive

## Step 1 - Install Apache into running container

`docker commit` command creates an image from container's changes.

Start an Debian container:

`docker run -it debian`. It will pull `debian` image to 
your local system if it does not exist already.

After pulling image, it will start container and open a shell 
into running container.

We'll install Apache into running container.
`apt-get update && apt-get install apache2 -y`

`exit`

## Inspect the changes

You can get the ID of container using `docker ps -a`. Check the first 
entry with image name as `debian`.

We can inspect changes to files and directories on a container's filesystem 
using `docker diff <yourContainerId>`.

This show the list of added, changed or deleted with capital `A`, `C` or `D` 
respectively prefixed with each file. 

## Step 3 - Create image using `docker commit`

You can create a new image from changes using following command.
`docker commit <yourContainerId>`

Run the image using `docker run -it <newImageId>`.

## Tag your image

You can tag your newly created image using `docker tag <newImageId> webserver`.

You can get id of image you want to tag using 
`docker images | grep debian`.

After tagging the image, you can run it with a tag.
`docker run -it webserver`