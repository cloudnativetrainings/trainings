package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", helloServer)
	http.ListenAndServe(":80", nil)
}

func helloServer(writer http.ResponseWriter, request *http.Request) {
	fmt.Fprintf(writer, "Hello")
}
