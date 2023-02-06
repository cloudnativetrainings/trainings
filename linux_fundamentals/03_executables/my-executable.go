package main

import (
	"fmt"
	"time"
)

func main() {
	for {
		fmt.Println("Hello Go!")
		time.Sleep(5 * time.Second)
	}
}
