package main

import (
	"fmt"
	"html/template"
	"net/http"
	"os"
	"path/filepath"
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
	Loader func(http.ResponseWriter, *http.Request, Data) (Data, error)
}

type ErrorRedirect struct {
	URL  string
	Code int
}

func (e ErrorRedirect) Error() string {
	return fmt.Sprintf("redirect to %s with code %d", e.URL, e.Code)
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
			nd, err := p.Loader(w, r, data)
			if err != nil {
				if redirect, ok := err.(ErrorRedirect); ok {
					http.Redirect(w, r, redirect.URL, redirect.Code)
					return
				}
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
	http.HandleFunc("GET /{$}", func(w http.ResponseWriter, r *http.Request) {
		handle([]Component{root, loggedOut, pageIndex})(w, r)
	})

	http.HandleFunc("GET /login", func(w http.ResponseWriter, r *http.Request) {
		handle([]Component{root, loggedOut, login})(w, r)
	})

	// static assets and 404s
	staticFS := http.FileServer(http.Dir("static"))
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		cleanPath := filepath.Clean(r.URL.Path)
		info, err := os.Stat(filepath.Join("static", cleanPath))
		if err == nil && !info.IsDir() {
			staticFS.ServeHTTP(w, r)
			return
		}
		w.WriteHeader(http.StatusNotFound)
		handle([]Component{root, loggedOut, pageNotFound})(w, r)
	})

	fmt.Println("~ Studio is up on port 4444 ~")
	if err := http.ListenAndServe(":4444", nil); err != nil {
		fmt.Println("Server error:", err)
	}
}
