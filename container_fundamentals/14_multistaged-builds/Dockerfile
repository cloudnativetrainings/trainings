FROM golang:1.19.1-alpine3.16
RUN mkdir /build
ADD main.go /build/
WORKDIR /build
RUN go mod init myapp && CGO_ENABLED=0 GOOS=linux go build -o main .
ENTRYPOINT [ "./main" ]
