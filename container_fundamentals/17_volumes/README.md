# Volumes

In this training you will learn how to make data persistent in your container.

## Inspect the Dockerfile and build the Docker image

```bash
docker build -t volumes:1.0.0 .
```

## RW layer

The RW-layer only makes changes persistent until the container gets removed.

```bash
# Create the container
docker run -it -d --name rw-layer volumes:1.0.0

# Printout the content of the file
docker exec -it rw-layer cat /data/file.txt

# Stop the container
docker stop rw-layer

# Restart the container
docker start rw-layer

# Pritout the content of the file again
# Note that the file contains the timestamps from the first run
docker exec -it rw-layer cat /data/file.txt

# Remove the container
# Note that all changes get lost
docker rm -f rw-layer
```

## Docker-managed volumes

Docker-managed volumes are managed by docker.

```bash
# Create the container
docker run -it -d --name docker-managed-volume -v /data volumes:1.0.0

# Printout the content of the file
docker exec -it docker-managed-volume cat /data/file.txt

# Cleanup all pre-existing volumes
# Note that Docker will not delete volumes of running containers
docker volume prune

# List all volumes
docker volume ls

# Show the details of the volume via `volume inspect`
docker volume inspect <VOLUME-NAME>

# Show the details of the volume via `inspect`
docker inspect docker-managed-volume | grep -A10 Mounts

# Change the content of the file on the host
sudo bash -c 'echo text from host >>  <HOST-VOLUME-PATH>/file.txt'

# Printout the content of the file
# Note that your change is also in
docker exec -it docker-managed-volume cat /data/file.txt

# Delete the container
docker rm -f docker-managed-volume 

# List the volumes
# Note that the volume is not deleted yet
docker volume ls

# Cleanup all volumes
docker volume prune

# Try to printout the content of the file
# Note that the file does not exist anymore
sudo cat <HOST-VOLUME-PATH>/file.txt
```

## Bind mount volumes

Bind mount volumes let you manage the lifecycle of your data youself.

```bash
# Create the container
docker run -it -d --name bind-mount-volume -v $PWD/data:/data volumes:1.0.0

# Check the content of the file `file.txt` in the folder `data` in your current directory
cat data/file.txt

# Printout the volumes
# Note that the volume is not managed by docker
docker volume ls

# Delete the container
docker rm -f bind-mount-volume

# Cleanup all volumes
docker volume prune

# Check the content of the file `file.txt` again
# Note that the file still exists 
cat data/file.txt
```
