
# ip address
```bash

ip address
curl https://ipinfo.io/ip
curl https://wtfismyip.com/json
```

# webserver
```bash
apt install nginx

systemctl status nginx

cat /lib/systemd/system/nginx.service


```

# curl
```bash
curl localhost
systemctl stop nginx
curl localhost
systemctl start nginx

curl localhost:80
curl http://localhost:80
curl external ip
curl --verbose localhost

# http response
curl -I localhost
curl -i localhost

# download files
curl https://www.google.com/favicon.ico --output google_favicon.ico

```

# DNS
```bash

nslookup google.com

```

# ports
```bash

apt install net-tools

netstat -tulpen | grep 8088
systemctl list-units  -t service --state active | grep -i openlitespeed
systemctl stop lshttpd
systemctl disable lshttpd
apt list --installed | grep openlitespeed
apt remove openlitespeed -y
```

# webserver benchmarking
```bash
apt-get install apache2-utils

# Suppose we want to see how fast Yahoo can handle 100 requests, with a maximum of 10 requests running concurrently:
ab -n 1000 -c 100 http://localhost:80/
# TODO hint to last /

```

# port scanning
```bash

apt install nmap

nmap localhost

# detect OS and services 
nmap -A localhost

# scan the top ports
nmap --top-ports 100 localhost
```