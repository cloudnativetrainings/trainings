# Docker Compose
In this course we will install a minimal Prometheus stack via Docker Compose. 

1. Download Docker Compose
```bash
# Get Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# Make Docker Compose executable
sudo chmod +x /usr/local/bin/docker-compose
# Verify the installation
docker-compose version
```
2. Create a folder and cd into it
```bash
mkdir compose
cd compose
```
3. Create a config file for Prometheus called `prometheus.yml`
```yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
    - targets: ['prometheus:80']
      labels:
        alias: 'prometheus'
  - job_name: 'cadvisor'
    static_configs:
    - targets: ['cadvisor:8080']
      labels:
        alias: 'cadvisor'
```
4. Create the Docker Compose file called `docker-compose.yml`
```yml
version: '3.4'
services:
  prometheus:
    image: 'prom/prometheus:latest'
    container_name: prometheus
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
    ports:
      - '9090:9090'
  cadvisor:
    image: 'google/cadvisor:latest'
    container_name: cadvisor
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
      - /dev/disk:/dev/disk/:ro
    ports:
      - '8080:8080'
  grafana:
    image: grafana/grafana
    container_name: grafana
    ports:
      - '80:3000'
```
5. Start all containers
```bash
docker-compose up -d
# Verify everything is working
docker ps
# Check the exposed metrics of CAdvisor
curl localhost:8080/metrics
# Visit Grafana in your Browser (User admin, Password admin)
http://<EXTERNAL-IP>
```
6. Create a Datasource of type `Prometheus` and the URL `http://prometheus:9090`
7. Import the Dashboard with id `193`. Set the Datasource to the previously generated.
