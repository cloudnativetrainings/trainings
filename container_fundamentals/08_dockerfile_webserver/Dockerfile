FROM ubuntu:20.10
RUN apt-get update && apt-get install apache2 -y && apt-get clean
COPY index.html /var/www/html/index.html
CMD [ "apache2ctl", "-DFOREGROUND" ]