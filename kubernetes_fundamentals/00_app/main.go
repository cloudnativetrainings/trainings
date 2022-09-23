package main

import (
	"bufio"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"syscall"
	"time"

	log "github.com/sirupsen/logrus"
)

var alive = true
var ready = true

func main() {

	go handleStdin()
	go handleLifecycle()

	http.HandleFunc("/", handleRoot)
	http.HandleFunc("/liveness", handleLiveness)
	http.HandleFunc("/readiness", handleReadiness)
	http.ListenAndServe(":8080", nil)
}

func handleStdin() {
	reader := bufio.NewReader(os.Stdin)
	for {
		text, _ := reader.ReadString('\n')
		text = strings.Replace(text, "\n", "", -1)
		if text != "" {
			handleCommand(text)
		}
	}
}

func handleCommand(command string) {
	if command == "set ready" {
		log.Info("Set application to ready")
		ready = true
	} else if command == "set unready" {
		log.Info("Set application to unready")
		ready = false
	} else if command == "set alive" {
		log.Info("Set application to alive")
		alive = true
	} else if command == "set dead" {
		log.Info("Set application to dead")
		alive = false
	} else {
		log.Infof("Unknown command '%s'", command)
	}
}

func handleRoot(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "<h1>")
	fmt.Fprintf(w, "Pod Name: %s<br>", os.Getenv("POD_NAME"))
	fmt.Fprintf(w, "Pod IP: %s<br>", os.Getenv("POD_IP"))
	fmt.Fprintf(w, "Live: %t<br>", alive)
	fmt.Fprintf(w, "Ready: %t<br>", ready)
	fmt.Fprintf(w, "</h1>")
}

func handleLiveness(w http.ResponseWriter, r *http.Request) {
	if alive {
		w.WriteHeader(http.StatusOK)
	} else {
		w.WriteHeader(http.StatusInternalServerError)
	}
}

func handleReadiness(w http.ResponseWriter, r *http.Request) {
	if ready {
		w.WriteHeader(http.StatusOK)
	} else {
		w.WriteHeader(http.StatusServiceUnavailable)
	}
}

func handleLifecycle() {
	signalChanel := make(chan os.Signal, 1)
	signal.Notify(signalChanel, syscall.SIGTERM)
	exitChanel := make(chan int)
	go func() {
		for {
			s := <-signalChanel
			if s == syscall.SIGTERM {
				log.Info("Got SIGTERM signal")
				log.Info("Starting Graceful Shutdown")
				for i := 0; i < 10; i++ {
					log.Infof("Graceful shutdown took %d seconds", i)
					time.Sleep(1 * time.Second)
				}
				log.Info("Graceful Shutdown has finished")
				exitChanel <- 0
			} else {
				log.Info("Got unknown signal")
				exitChanel <- 1
			}
		}
	}()
	exitCode := <-exitChanel
	os.Exit(exitCode)
}
