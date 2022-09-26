# Caching

In this training, you will learn how to write Dockerfiles which will decrease build time due to using caches.

>Navigate to the folder `13_caching` from CLI, before you get started.

## Inspect the Dockerfile and the server.js file

```bash
cat Dockerfile
cat server.js
```

## Build and run the docker image

```bash
docker build -t node:1.0.0 .
docker run -it --rm -p 80:80 node:1.0.0
```

>Visit the site via the external IP of your node

## Re-build the docker image

```bash
docker build -t node:1.0.0 .
```

>Note that all layers are taken from the cache.

## Adapt the application and re-build the docker image

Change the message to something different in the file `server.js`

```bash
docker build -t node:1.0.0 .
docker run -it --rm -p 80:80 node:1.0.0
```

>Visit the site via the external IP of your node
>Note that all layers starting from the `RUN npm install` layer is not taken from the cache. On bigger projects, this can increase your build times significantly.

## Fix the Dockerfile

* Change the content of the Dockerfile to this

  ```docker
  FROM node:12
  WORKDIR /app
  COPY package.json .
  RUN npm install
  COPY server.js .
  CMD [ "npm", "start" ]
  ```

* Do the initial build

  ```bash
  docker build -t node:2.0.0 .
  ```

* Re-build the docker image

Change the message to something different in the file `server.js`.

```bash
docker build -t node:2.0.0 .
docker run -it --rm -p 80:80 node:2.0.0
```

>Visit the site via the external IP of your node
>Note the layers which are taken from the cache.

## Cleanup

Remove all the images

```bash
docker rmi -f $(docker images -qa)
```

[Jump to Home](../README.md) | [Previous Training](../12_shell-vs-cmd-form-PID1/README.md) | [Next Training](../14_multistaged-builds/README.md)
