IMAGE_REPOSITORY = quay.io/kubermatic-labs
APPLICATION_NAME = training-application
BUILD_VERSION = 2.0.0
BUILD_VERSION_A = 2.0.0-A
BUILD_VERSION_B = 2.0.0-B
BUILD_VERSION_DISTROLESS = 2.0.0-distroless

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

.PHONY: docker-push-dragons
docker-push-dragons:
	docker build -f Dockerfile-A -t ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${BUILD_VERSION_A} .
	docker push ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${BUILD_VERSION_A}
	docker build -f Dockerfile-B -t ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${BUILD_VERSION_B} .
	docker push ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${BUILD_VERSION_B}

.PHONY: docker-push-distroless
docker-push-distroless:
	# docker buildx create --use --platform=linux/arm64,linux/amd64 --name multi-platform-builder
	# docker buildx inspect --bootstrap
	docker buildx build --push --platform linux/arm64,linux/amd64 -f Dockerfile-distroless --tag ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${BUILD_VERSION_DISTROLESS} .

.PHONY: docker-push-all
docker-push-all: docker-build docker-push docker-push-dragons docker-push-distroless
