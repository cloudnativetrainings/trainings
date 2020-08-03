# Advanced Networking

## Creating a new network

List all container networks:

```bash
docker network ls
```

Now let's create a new network called `dev`:

```bash
docker network create dev
```

And have a look at the list of networks again with `docker network ls`.

## Running containers on a network

First let's start a container on our newly created network:

```bash
docker run -d --name search --net dev elasticsearch
```

Now we can ping this container from another one running on the new network:

```bash
docker run -ti --net dev alpine sh
```

From there we can ping the `search` container:

```bash
/ # ping search
```

The DNS resolution happens via a dynamically adapted `/etc/hosts` file:

```bash
/ # cat /etc/hosts
```

## Running the trainingwheels app

Now let's run the jpetazzo/trainingwheels image and see what it does:

```bash
docker run --net dev -d -P jpetazzo/trainingwheels
```

and look if the port is correctly allocated:

```bash
docker ps -l
```

When accessing the port we get an error. Seems we will need a redis data store, too:

```bash
docker run --net dev --name redis -d redis
```

Since we named the redis container specifically `redis` our trainingwheels app can now access it and should work. This name is a global one, but what if we want to have multiple redis instances running?

Let's delete the previous redis instance:

```bash
docker rm -f redis
```

And deploy a new one with an alias scoped to just our `dev` network:

```bash
docker run --net dev --net-alias redis -d redis
```

Now the name is only unique to the network the container is running in. DNS resolving is local to a network, so names can only be resolved from containers running in the same network:

```bash
docker run --rm alpine ping search
```

## Two containers, only one alias

Let's create a new network `prod` and try to run multiple elasticsearch instances behind a single `net-alias` in it:

```bash
docker create network prod
```

```bash
docker run -d --name prod-es-1 --net-alias search --net prod elasticsearch

docker run -d --name prod-es-2 --net-alias search --net prod elasticsearch
```

Let's see what happens with the `search` net-alias:

```bash
docker run --net prod --rm alpine nslookup search
```

What will happen when we connect to this new elasticsearch alias in comparison to the single instance in dev?

```bash
docker run --rm --net dev centos curl -s
```

```bash
docker run --rm --net prod centos curl -s
```

## Assinging IPs

We can create a new network with a custom CIDR

```bash
docker network create --subnet 10.66.0.0/16 pubnet
```

And we can start a new container in this new network also with an IP address that we specified:

```bash
docker run --net pubnet --ip 10.66.66.66 -d nginx
```


