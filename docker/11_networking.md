# Networking

## Running a basic web server

Run a container if `nginx` image.
`docker run -d -P --name myweb nginx`

You can find ports exposed by container in `docker ps`. Check `PORTS` 
column.

Also you can see web running in container using 
`curl localhost:$(docker inspect myweb -f '{{(index (index .NetworkSettings.Ports "80/tcp") 0).HostPort}}')`

Alternatively you can use `docker port myweb 80` to get the exposed ports.

Port can be manually exposed using `-p` flag. 
`docker run -d -p 8080:80 --name myweb1 nginx`

Above command will start a container from image `nginx` with internal port `80`
exposed to external port `8080`.

## Locating an IP address

You can get the IP address of running container using
`docker inspect --format '{{ .NetworkSettings.IPAddress }}' myweb1`

## Check connectivity

You can check network connectivity to container IP using
`ping $(docker inspect --format '{{ .NetworkSettings.IPAddress }}' myweb1)`

## Bridge networking

It is a default networking mode if you don't specify networking mode explicitly
using `--net` option.

It creates `MASQUERADE` and `DNAT` iptables rules for outbound and inbound traffic 
respectively.

Check iptables rules for our container using
`iptables -t nat -L | grep $(docker inspect --format '{{ .NetworkSettings.IPAddress }}' myweb1)`

Get bridge details using `docker inspect myweb1 -f '{{json .NetworkSettings.Networks}}'`

## Null driver

This mode creates network isolation for container. A container can't send and 
receive network traffic. It can only see `lo` interface.

You can used this mode like `docker run -d --net none --name nullnetdemo nginx`.

Even though it is a container running web server, you can't connect to it.

Check network details using `docker inspect nullnetdemo -f '{{json .NetworkSettings.Networks}}'`

It shows `none` in networks.

## Host driver

When using this driver, container shares network with host. It can be used using 
`--net host` option.

You can create one like `docker run -d -p 8080:80 --net host --name hostnetdemo nginx`.

It can be easily checked using `docker inspect hostnetdemo -f '{{json .NetworkSettings.Networks}}'`

## Container driver

This driver is used to re-use network stack of another container.

It can be used using `--net container:id` option.

Create first container using `docker run -d  --name maincontainer nginx`

Spawn second container using `docker run --net container:maincontainer --name secondarycontainer -d busybox sh -c "while true; do $(echo date); sleep 1; done"`

Our `secondarycontainer` will reuse the network stack of first container. We can 
access `nginx` running at port `80` using `localhost`.

`docker exec -it secondarycontainer sh`

`wget localhost`
`cat index.html`

You can see content of downloaded `index.html` page from `nginx`.