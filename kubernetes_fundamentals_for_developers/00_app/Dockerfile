FROM --platform=linux/amd64 golang:alpine3.15 as builder
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY main.go ./
RUN go build -o app

FROM --platform=linux/amd64 alpine:3.15
WORKDIR /app
COPY --from=builder /src/app /app/app
COPY conf/app.conf ./conf/
ENTRYPOINT [ "./app" ]
