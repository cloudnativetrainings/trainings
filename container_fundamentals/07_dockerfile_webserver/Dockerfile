FROM ubuntu:22.04
RUN apt-get update && apt-get install nginx -y && apt-get clean
COPY index.html /usr/share/nginx/html/index.html
ENTRYPOINT [ "/etc/init.d/nginx" ]
CMD [ "start" ]