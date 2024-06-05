FROM --platform=linux/amd64 golang:alpine3.15 as builder
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY main.go ./
RUN go build -o training-application

FROM --platform=linux/amd64 alpine:3.15
WORKDIR /app
COPY --from=builder /src/training-application /app/training-application
COPY conf/app.conf ./conf/
ENTRYPOINT [ "./training-application" ]
