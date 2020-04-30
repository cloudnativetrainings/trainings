#!/bin/bash

# build application
#./gradlew clean build

# run application
#java -jar build/libs/app-0.0.1.jar

# containerize
docker build -t test:0.0.4 .

# run container
#sudo rm -rf $(pwd)/hprof
#docker run -it --rm --name memory-leak -v $(pwd)/hprof:/app/hprof -p 8080:8080 --memory 8g memory-leak:0.0.1

# k8s
#minikube start virtualbox --cpus 4 --memory 4096
#eval (minikube docker-env)
#minikube service memory-leak

# prometheus
#curl -X POST http://192.168.99.103:32000/-/reload
