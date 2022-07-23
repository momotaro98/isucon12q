package main

import (
	isuports "github.com/isucon/isucon12-qualify/webapp/go"

	"log"
	"net/http"
	_ "net/http/pprof"
	"runtime"
)

func main() {
	runtime.SetBlockProfileRate(1)
	runtime.SetMutexProfileFraction(1)
	go func() {
		log.Println(http.ListenAndServe("localhost:6060", nil))
	}()
	isuports.Run()
}
