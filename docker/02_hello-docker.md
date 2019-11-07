# Hello Docker

1. Run an Ubuntu Container
```bash
docker run -it -p 80:80 ubuntu
```
2. Install a web server
```bash
apt update && apt install -y apache2
```
3. Run the web server
```bash
apache2ctl -DFOREGROUND
```
4. Visit the welcome page of your browser. To get the external IP you can visit https://console.cloud.google.com/networking/addresses/.
5. Stop the process in the Docker Container via the CTRL+C keys.
6. Take a look at the running Docker Containers.
```bash
docker ps
```
7. The Container is already in state `EXITED`. To see the Container do the following
```bash
docker ps -a
```
8. Remove the Container
```bash
docker rm <TAB>
```