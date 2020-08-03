# Inspect

## Name a container

So far we have referenced containers only with their ID or with a prefix, but 
containers can also be referenced by their names also.

Create a new container with name `counter` from image `loodse/counter` using 
```bash
docker run -d -it --name counter loodse/counter
```

Now the container with name `counter` is started, you can perform various operations
on containers by using its name.

Check the logs using 
```bash
docker logs counter
```

## Inspecting a container

There are many configurations and details associated with each running container
like IP Address, Mac Address, Ports exposed, Creation timestamp and many others.

You can retrieve these details using command 
```bash
docker inspect counter
```

### Using --format
```bash
docker inspect
```
command outputs lot of details in parsable json. You can get particular fields from that.

```bash
docker inspect -f '{{json .Created}}' counter
```
This way you can directly retrieve `Created` field from json output.