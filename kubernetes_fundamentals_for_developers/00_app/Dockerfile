FROM --platform=linux/amd64 golang:alpine3.15 as builder
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY main.go ./
RUN go build -o kad-training

FROM --platform=linux/amd64 alpine:3.15
WORKDIR /app
COPY --from=builder /src/kad-training /app/kad-training
COPY app.conf ./conf/
ENTRYPOINT [ "./kad-training" ]
