package main

import (
	"bytes"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"os/signal"
	"time"
)

func main() {
	done := make(chan os.Signal)
	signal.Notify(done, os.Interrupt, os.Kill)

	go func() {
		log.Println("\x1b[33;1mListening at port 8080...\x1b[0m")
		if err := http.ListenAndServe(":8080", http.HandlerFunc(serve)); err != nil {
			log.Fatal(err)
		}
	}()

	<-done
	log.Println("Shutting down server...")
}

func serve(res http.ResponseWriter, req *http.Request) {
	var (
		size = 10000000
		b    = make([]byte, size)
		buf  = bytes.NewBuffer(b)
	)

	log.Printf("\x1b[32;1mReceived request. Writing %dMB of data to /dev/null...\x1b[0m\n", size/1000000)
	now := time.Now()
	buf.WriteTo(ioutil.Discard)
	duration := time.Since(now)
	log.Printf("\x1b[32;1mI/O completed. Time elapsed: %s\x1b[0m\n", duration)
	time.Sleep(10 * time.Millisecond)
}
