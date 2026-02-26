package main

import (
	"fmt"
	"html/template"
	"net/http"
)

const (
	ext = ".tmpl"
)

type Data map[string]any

func MergeData(maps ...Data) Data {
	merged := make(Data)
	for _, m := range maps {
		for k, v := range m {
			merged[k] = v
		}
	}
	return merged
}

type Component struct {
	Name   string
	Loader func(http.ResponseWriter, *http.Request) (Data, error)
}

func handle(Pages []Component) http.HandlerFunc {
	lp := len(Pages)
	files := make([]string, lp)
	for i, p := range Pages {
		files[i] = p.Name + ext
	}

	tmpl, err := template.ParseFiles(files...)
	if err != nil {
		return func(w http.ResponseWriter, r *http.Request) {
			http.Error(w, "template error: "+err.Error(), http.StatusInternalServerError)
		}
	}

	return func(w http.ResponseWriter, r *http.Request) {
		data := make(Data)
		for _, p := range Pages {
			nd, err := p.Loader(w, r)
			if err != nil {
				http.Error(w, "loader error: "+err.Error(), http.StatusInternalServerError)
				return
			}
			data = MergeData(data, nd)
		}

		if err := tmpl.Execute(w, data); err != nil {
			http.Error(w, "template error: "+err.Error(), http.StatusInternalServerError)
		}
	}
}

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		handle([]Component{root, loggedOut, pageIndex})(w, r)
	})

	fmt.Println("~ Studio is up on port 4444 ~")
	if err := http.ListenAndServe(":4444", nil); err != nil {
		fmt.Println("Server error:", err)
	}
}
