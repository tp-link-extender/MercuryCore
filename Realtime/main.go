package main

import (
	"fmt"
	"net/http"

	c "github.com/TwiN/go-color"
	"github.com/tmaxmax/go-sse"
)

func main() {
	servers := map[string]*sse.Server{}
	router := http.NewServeMux()

	router.HandleFunc("POST /{topic}", func(w http.ResponseWriter, r *http.Request) {
		m := &sse.Message{}
		// read the body
		body := make([]byte, r.ContentLength)
		r.Body.Read(body)

		m.AppendData(string(body))
		topic := r.PathValue("topic")
		fmt.Println("POST /" + topic)

		if servers[topic] == nil {
			servers[topic] = &sse.Server{}
		}
		s := servers[topic]
		s.Publish(m)
		w.WriteHeader(200)
	})

	router.HandleFunc("GET /{topic}", func(w http.ResponseWriter, r *http.Request) {
		fmt.Println("getting")
		// set access control headers
		w.Header().Set("Access-Control-Allow-Origin", "*")
		topic := r.PathValue("topic")
		fmt.Println("GET /" + topic)

		if servers[topic] == nil {
			servers[topic] = &sse.Server{}
		}
		s := servers[topic]
		s.ServeHTTP(w, r)
	})

	router.HandleFunc("OPTIONS /", func(w http.ResponseWriter, r *http.Request) {
		// cors moments
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Headers", "*")
		w.WriteHeader(200)
	})

	fmt.Println(c.InGreen("We up on that 5555"))
	// generate some random certificate wdc it won't be exposed to the internet
	err := http.ListenAndServe(":5555", router)
	if err != nil {
		fmt.Println(c.InRed("Error: " + err.Error()))
	}
}
