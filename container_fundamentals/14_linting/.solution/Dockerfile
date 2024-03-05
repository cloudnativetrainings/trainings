FROM ubuntu:23.10

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends nginx=1.20.1 -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD [ "nginx", "-g", "daemon off;" ]
