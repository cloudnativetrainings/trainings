# Logs

## Inspect the logs of a running container

* Create a container

```bash
docker run -d --name redis redis:6.0.8
```

* Get the logs of the container

```bash
docker logs redis
```

* Watch the logs of the container

```bash
docker logs -f redis
```

>To exit from watch mode, simply use Ctrl+c.

## Globally customize the log-driver

You can costumize the log-driver in the file `/etc/docker/daemon.json` via these options:

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3" 
  }
}
```

>This sets the log-driver to `json-file` which is the default. Furthermore, you can define log file rotation by setting the log-opts properties `max-size` and `max-file` .

## Run a container with a specific log-driver

* Syslog log-driver
  The Syslog log driver will write all the container logs to the central syslog on the host. This log-driver is designed to be used when syslog is being collected and aggregated by an external system.

```bash
docker run -d --name redis-syslog --log-driver=syslog redis:6.0.8
```

  You can get the logs via

```bash
cat /var/log/syslog | grep $(docker ps -aqf "name=redis-syslog")
```

* Disable logging

```bash
docker run -d --name redis-none --log-driver=none redis:6.0.8
```

## Inspect the log-driver

```bash
docker inspect --format '{{ .HostConfig.LogConfig }}' redis
```

## Cleanup

```bash
# Remove all the containers
docker rm -f $(docker ps -qa)

#  Remove all the images
docker rmi -f $(docker images -qa)
```