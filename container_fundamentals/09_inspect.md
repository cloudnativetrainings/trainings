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





## Create a container

Now we have image downloaded and ready to use, we can create container using
```bash
docker run -d --name my-nginx nginx:1.19.2
```

The `-d` flag instructs docker to create container and run it in background.

The `--name my-nginx` names the container.

## Inspect a container

```bash
docker inspect my-nginx
```

It gives you whole lot of information about running container including IP, MacAddress, Hostname etc.