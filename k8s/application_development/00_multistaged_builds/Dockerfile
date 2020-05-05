FROM gradle:6.3.0-jdk14 AS builder
COPY --chown=gradle:gradle . /code
WORKDIR /code
RUN gradle build --no-daemon

FROM openjdk:14-jdk-slim-buster
COPY --from=builder /code/build/libs/app-0.0.1.jar /srv/app/app-0.0.1.jar
WORKDIR /srv/app
ENV JAVA_OPTS="-server -XshowSettings:vm"
ENV JAVA_OPTS="-XX:InitialRAMPercentage=50 -XX:MaxRAMPercentage=70 $JAVA_OPTS"
ENTRYPOINT java $JAVA_OPTS -jar /srv/app/app-0.0.1.jar
