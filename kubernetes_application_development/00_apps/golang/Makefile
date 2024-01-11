IMAGE_REPOSITORY = quay.io/kubermatic-labs
APPLICATION_NAME = kad-training
BUILD_VERSION = 1.0.0-go
A_BUILD_VERSION = 1.0.1-go
B_BUILD_VERSION = 1.0.2-go
C_BUILD_VERSION = 1.1.0-go

.PHONY: update-dependencies
update-dependencies: 
	go get -u
	go mod tidy

.PHONY: build
build: 
	go build -o ${APPLICATION_NAME}

.PHONY: run
run: build
	./${APPLICATION_NAME}

.PHONY: docker-build
docker-build: build
	docker build -t ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${BUILD_VERSION} .

.PHONY: docker-run
docker-run: docker-build
	docker run -it --rm -p 8080:8080 -m=10m --cpus=".5" --name ${APPLICATION_NAME} ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${BUILD_VERSION}

.PHONY: docker-push
docker-push: docker-build
	docker push ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${BUILD_VERSION}

.PHONY: docker-push
docker-push-all: docker-push
	docker build -f Dockerfile-A -t ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${A_BUILD_VERSION} .
	docker push ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${A_BUILD_VERSION}
	docker build -f Dockerfile-B -t ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${B_BUILD_VERSION} .
	docker push ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${B_BUILD_VERSION}
	docker build -f Dockerfile-C -t ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${C_BUILD_VERSION} .
	docker push ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${C_BUILD_VERSION}

docker-multiarch:
	docker buildx build --push --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --tag ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${BUILD_VERSION} .
	docker buildx build --push --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --tag ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${A_BUILD_VERSION} .
	docker buildx build --push --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --tag ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${B_BUILD_VERSION} .
	docker buildx build --push --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --tag ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${C_BUILD_VERSION} .
