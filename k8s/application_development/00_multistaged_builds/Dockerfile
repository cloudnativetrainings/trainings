FROM gradle:6.3.0-jdk14 AS builder
ARG BUILD_VERSION=0.0.0
COPY --chown=gradle:gradle . /code
WORKDIR /code
RUN gradle build --no-daemon -Pversion=$BUILD_VERSION

FROM openjdk:14-jdk-slim-buster
ARG BUILD_VERSION=0.0.0
COPY --from=builder /code/build/libs/app-$BUILD_VERSION.jar /srv/app/app.jar
WORKDIR /srv/app
ENV JAVA_OPTS="-server -XshowSettings:vm"
ENV JAVA_OPTS="-XX:InitialRAMPercentage=50 -XX:MaxRAMPercentage=70 $JAVA_OPTS"
ENV APP=./app-$BUILD_VERSION.jar
ENTRYPOINT java $JAVA_OPTS -jar $APP

# TODO Starting Application on my-app with PID 6 
