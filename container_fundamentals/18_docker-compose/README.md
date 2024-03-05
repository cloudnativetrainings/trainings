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
# via docker
docker ps

# via docker compose
docker compose ps
```

* Verify the exposed metrics of CAdvisor. Note that there are a lot of metrics.

```bash
curl localhost:8080/metrics
```

* Visit Grafana in your Browser (User admin, Password admin) on port 80 via http.

>You can get the external IP via the command `make get-external-ip` in your home directory.

## Create a Datasource

Create a Datasource of type `Prometheus` and the URL `http://prometheus:9090`

## Import a Dashboard

Import the Dashboard with id `193`. Set the Datasource to the previously generated.

## Cleanup

```bash
# Remove all the containers
docker compose down

# Remove all the images
docker rmi -f $(docker images -qa)
```
