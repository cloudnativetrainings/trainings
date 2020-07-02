FROM gradle:6.3.0-jdk14 AS builder
ARG BUILD_VERSION=0.0.0
COPY --chown=gradle:gradle . /code
WORKDIR /code
RUN gradle build --no-daemon -Pversion=$BUILD_VERSION

FROM openjdk:14-jdk-slim-buster
RUN apt update && apt install curl -y
ARG BUILD_VERSION=0.0.0
ENV BUILD_VERSION=$BUILD_VERSION
COPY --from=builder /code/build/libs/frontend-$BUILD_VERSION.jar /srv/app/frontend-$BUILD_VERSION.jar
WORKDIR /srv/app

ENTRYPOINT java -server -XshowSettings:vm -XX:InitialRAMPercentage=50 -XX:MaxRAMPercentage=70 -jar /srv/app/frontend-$BUILD_VERSION.jar
