FROM golang:alpine3.15 as builder
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
RUN go build -o training-application

FROM alpine:3.15
WORKDIR /app
COPY --from=builder /src/training-application /app/training-application
ENTRYPOINT [ "./training-application" ]
