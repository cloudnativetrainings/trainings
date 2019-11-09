# Inspect

## Name a container

So far we have referenced containers only with their ID or with a prefix, but 
containers can also be referenced by their names also.

Create a new container with name `counter` from image `loodse/counter` using 
`docker run -d -it --name counter loodse/counter`.

Now the container with name `counter` is started, you can perform various operations
on containers by using its name.

Check the logs using `docker logs counter`.

## Inspecting a container

There are many configurations and details associated with each running container
like IP Address, Mac Address, Ports exposed, Creation timestamp and many others.

You can retrieve these details using command `docker inspect counter`.

### Using --format

`docker inspect` command outputs lot of details in parsable json. You can get 
particular fields from that.

`docker inspect -f '{{json .Created}}' counter`. This way you can directly
retrieve `Created` field from json output.