# Docker Compose

In this training, we will install a minimal Prometheus stack via Docker Compose.

>Navigate to the folder `18_docker-compose` from CLI, before you get started.

## Verify that docker compose is installed

>We have installed it during `00_setup` lab.

Verify the installation

```bash
docker compose version
```

## Inspect the file `prometheus.yaml`

```bash
cat prometheus.yaml
```

## Inspect the Docker Compose file called `docker-compose.yaml`

```bash
cat docker-compose.yaml
```

## Start all containers

* Using `docker compose`, start all the containers as follows.

  ```bash
  docker compose up -d
  ```

* Verify everything is working

  ```bash
  docker ps
  ```

* Verify the exposed metrics of CAdvisor

  ```bash
  curl localhost:8080/metrics
  ```

* Visit Grafana in your Browser (User admin, Password admin)

  ```bash
  http://<EXTERNAL-IP>
  ```

## Create a Datasource

Create a Datasource of type `Prometheus` and the URL `http://prometheus:9090`

## Import a Dashboard

Import the Dashboard with id `193`. Set the Datasource to the previously generated.

## Cleanup

* Remove all the containers

  ```bash
  docker compose down
  ```

* Remove all the images

  ```bash
  docker rmi -f $(docker images -qa)
  ```

[Jump to Home](../README.md) | [Previous Training](../17_volumes/README.md) | [Next Training](../19_privileged-container/README.md)
