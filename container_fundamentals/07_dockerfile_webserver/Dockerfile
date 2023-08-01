FROM ubuntu:23.10
RUN apt-get -y update && apt-get -y install nginx
COPY index.html /var/www/html/index.html
ENTRYPOINT ["/usr/sbin/nginx" ]
CMD [ "-g", "daemon off;" ]