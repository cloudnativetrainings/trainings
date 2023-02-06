# Networking

In this lab you will learn some useful tools to handle networking.

## Getting your IP Adresses

```bash
# getting the ip address of your internal network
ip address

# getting the external ip address (you can also use https://ipinfo.io/ip ;) )
curl https://wtfismyip.com/json
```

## Running a Webserver

```bash
# install nginx
apt install nginx

# check the state of the nginx service (note that you get the service config file with this command)
systemctl status nginx

# take a look into this file (this is how you configure services in Linux, but that is out of scope for this training)
cat /lib/systemd/system/nginx.service
```

## Accessing the Webserver

```bash
# get the html response via curl
curl localhost

# stop the nginx service
systemctl stop nginx

# now the curl will fail
curl localhost

# restart the nginx service again
systemctl start nginx

# try out the different ways to access the webserver
curl localhost
curl localhost:80
curl http://localhost:80
curl $(curl https://ipinfo.io/ip )

# get more info about the response
curl --verbose localhost

# get the metadata from the response
curl -I localhost

# downloading files with curl
curl https://www.google.com/favicon.ico --output google_favicon.ico
ls -alh google_favicon.ico
```

## Looking up DNS Entries

```bash
nslookup google.com
```

## Getting info about ports

Sometimes you are in the situation that some port is used by an application which you are not aware of. The following commands can be very helpful in those situations.
```bash
# install the package containing the netstat tool
apt install net-tools

# find the application which is using port 80
netstat -tulpen | grep 80

# check the active services
systemctl list-units  -t service --state active | grep -i nginx
```

# Benchmarking the Webserver

```bash
# install the package containing apache-ab
apt-get install apache2-utils

# send 1000 requests with concurrency set to 100 to our webserver (please note the last `/`, apache-ab is a little bit picky here)
ab -n 1000 -c 100 http://localhost:80/
```

# Port Scanning

Nmap is a very neat tool to detect security issues.
```bash
# install nmap
apt install nmap

# see the open ports on your machine
nmap localhost

# detect OS and services on your machine
nmap -A localhost
```

TODO slides discuss systemctl and daemons
