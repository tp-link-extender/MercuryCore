package main

import (
	"fmt"
	"html/template"
	"net/http"
)

func main() {
	// test http
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// load index.tmpl
		tmpl, err := template.ParseFiles("index.tmpl")
		if err != nil {
			http.Error(w, "Internal Server Error", http.StatusInternalServerError)
			return
		}
		tmpl.Execute(w, nil)
	})

	fmt.Println("~ Studio is up on port 4444 ~")
	http.ListenAndServe(":4444", nil)
}
