# Images Interactive

In this task you will create a new image via interactive commands. Note that this approach is not recommended for production usecases. Use Dockerfiles instead.

## Make a change in a container

Start an Debian container:
```bash
docker run -it --name my-debian debian:10.5
```

Create a new file in the container
```bash
touch /my.file
exit
```

## Inspect the changes

We can inspect changes to files and directories on a container's filesystem 
using 
```bash
docker diff my-debian
```
This show the list of added, changed or deleted with capital `A`, `C` or `D` 
respectively prefixed with each file. 

## Step Create image using `docker commit`

You can create a new image from changes using following command.
```bash
docker commit my-debian
```

Run the image using 
```bash
docker run -it <newImageId>
```

Verify that your file still exists in the new container
```bash
ls /
```

## Tag your image

You can tag your newly created image using 
```bash
docker tag <newImageId> my-image
```

After tagging the image, you can run it with a tag.
```bash
docker run -it my-image
```

Verify that your file still exists in the new container
```bash
ls /
```

## Cleanup

```bash
docker rm -f $(docker ps -qa)
```
