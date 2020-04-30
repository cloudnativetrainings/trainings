# build the application
FROM golang:1.14.2-alpine3.11 AS builder
WORKDIR /builder
COPY main.go .
RUN GOOS=linux GOARCH=amd64 go build -o main main.go

# run the application
FROM alpine:3.11.5
RUN apk --no-cache add ca-certificates
WORKDIR /app
COPY --from=builder /builder/main .
RUN chmod +x ./main
ENTRYPOINT ["./main"]
