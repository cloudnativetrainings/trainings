IMAGE_REPOSITORY = quay.io/kubermatic-labs
APPLICATION_NAME = seven-sins-application
BUILD_VERSION = 0.0.3

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
	docker run -it --rm -p 8080:8080 --name ${APPLICATION_NAME} ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${BUILD_VERSION}

.PHONY: docker-push
docker-push: docker-build
	docker push ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:${BUILD_VERSION}

.PHONY: docker-push-dragons
docker-push-dragons:
	docker build -f Dockerfile-A -t ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:A-${BUILD_VERSION} .
	docker push ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:A-${BUILD_VERSION}
	docker build -f Dockerfile-B -t ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:B-${BUILD_VERSION} .
	docker push ${IMAGE_REPOSITORY}/${APPLICATION_NAME}:B-${BUILD_VERSION}
