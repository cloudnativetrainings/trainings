# Webapp

## Downloading image

In this scenario you will bring up your very first container. 

To create a container you need image which will be the container 
created from. Images are usually hosted somewhere in an accessible 
location called Registry.

It is a single place to manage Docker images. Users can create account 
and push their own images to registry.

Use following command to search our desired image in registry.
`docker search loodse`

You will get list of images belongs to a user `loodse`.

Now we know that our desired image exists in registry, we need to pull 
it to our local system to create containers of it.

Execute `docker pull loodse/demo-www`. `docker pull` command 
downloads image from docker hub (which serves as a default registry for 
docker installation). 

You can see list of downloaded images using `docker images`.

You can see `loodse/demo-www` entry there.

## Creating a container

Now we have image downloaded and ready to use, we can create container using
`docker run -d loodse/demo-www`.
The `-d` flag instructs docker to create container and run it in background.

You can see list of running containers using `docker ps`. You can 
see an entry with `loodse/demo-www` string in `IMAGE` column. 

To interact with container you need `CONTAINER ID` which you can grab from 
first column.

## Inspect running container

We can get details of running container using `docker inspect` command. 
You can use that command like `docker inspect <CONTAINER ID>`.

It gives you whole lot of information about running container including IP, 
MacAddress, Hostname etc.

## List container

List all running container.

`docker ps`

The `docker ps` command only shows running containers by default. To see all containers, use the `-a` (or `--all`) flag:

`docker ps -a`

Let’s start a second webserver. 

`docker run -t -p 8080:80 loodse/demo-www`

With `docker ps` you see now two running containers.

***Use the second terminal***: `docker ps -a`

##### Terminate running container

Stop the started container. The main process inside the container will receive `SIGTERM`, and after a grace period, `SIGKILL`.

***Use the second terminal***: `docker stop --time 5 <yourContainerId>`

You can also restart your container, try:

`docker restart <yourContainerId>`

If you have e.g. an hanging container, it's possible to send the `SIGKILL` signal directly. Try

`docker kill <yourContainerId>`

