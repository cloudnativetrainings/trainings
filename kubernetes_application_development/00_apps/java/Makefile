IMAGE_REPOSITORY = quay.io/kubermatic-labs
APPLICATION_NAME = kad-training
BUILD_VERSION = 1.0.0-java
A_BUILD_VERSION = 1.0.1-java

.PHONY: docker-build
docker-build:
	docker build -t ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${BUILD_VERSION} . --build-arg BUILD_VERSION=${BUILD_VERSION}

.PHONY: docker-run
docker-run: docker-build
	docker run -it --rm -p 8080:8080 -m=10m --cpus=".5" --name ${APPLICATION_NAME} ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${BUILD_VERSION}

.PHONY: docker-push
docker-push: docker-build
	docker push ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${BUILD_VERSION}

.PHONY: docker-push-all
docker-push-all: docker-push
	docker build -f Dockerfile-A -t ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${A_BUILD_VERSION} . --build-arg BUILD_VERSION=${A_BUILD_VERSION}
	docker push ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${A_BUILD_VERSION}

docker-multiarch:
	docker buildx build --push --platform linux/arm64/v8,linux/amd64 --tag ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${BUILD_VERSION} .
	docker buildx build --push --platform linux/arm64/v8,linux/amd64 --tag ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${A_BUILD_VERSION} .
