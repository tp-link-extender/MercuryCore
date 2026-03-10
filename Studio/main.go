package main

import (
	"encoding/json"
	"fmt"
	"html/template"
	"net/http"
	"os"
	"path/filepath"
)

const (
	ext = ".tmpl"
)

type User struct {
	id, username string
}

// type Data map[string]any
type Data struct {
	User *User
	Data map[string]any
}

func MakeData() Data {
	return Data{
		Data: make(map[string]any),
	}
}

func (d Data) Merge(d2 Data) Data {
	d.User = d2.User
	for k, v := range d2.Data {
		d.Data[k] = v
	}
	return d
}

type Component struct {
	Name   string
	Loader func(http.ResponseWriter, *http.Request, Data) (Data, error)
}

type ErrorRedirect struct {
	Path string
	Code int
}

func (e ErrorRedirect) Error() string {
	return fmt.Sprintf("redirect to %s with code %d", e.Path, e.Code)
}

func handle(Pages []Component) http.HandlerFunc {
	lp := len(Pages)

	var noRender bool

	files := make([]string, lp)
	for i, p := range Pages {
		files[i] = p.Name + ext
		if p.Name == "" {
			noRender = true
		}
	}

	return func(w http.ResponseWriter, r *http.Request) {
		data := MakeData()
		for _, p := range Pages {
			if p.Loader == nil {
				continue
			}

			nd, err := p.Loader(w, r, data)
			if err != nil {
				if redirect, ok := err.(*ErrorRedirect); ok {
					http.Redirect(w, r, redirect.Path, redirect.Code)
					return
				}
				http.Error(w, "loader error: "+err.Error(), http.StatusInternalServerError)
				return
			}
			// data = MergeData(data, nd)
			data = nd
		}

		if noRender {
			// just json encode the data bruh
			w.Header().Set("Content-Type", "application/json")
			if err := json.NewEncoder(w).Encode(data); err != nil {
				http.Error(w, "json encode error: "+err.Error(), http.StatusInternalServerError)
			}
			return
		}

		tmpl, err := template.ParseFiles(files...)
		if err != nil {
			http.Error(w, "template parse error: "+err.Error(), http.StatusInternalServerError)
			return
		}

		if err := tmpl.Execute(w, data); err != nil {
			http.Error(w, "template exec error: "+err.Error(), http.StatusInternalServerError)
		}
	}
}

func main() {
	http.HandleFunc("GET /{$}", func(w http.ResponseWriter, r *http.Request) {
		handle([]Component{root, loggedOut, pageIndex})(w, r)
	})

	http.HandleFunc("/login", func(w http.ResponseWriter, r *http.Request) {
		handle([]Component{root, loggedOut, pageLogin})(w, r)
	})

	http.HandleFunc("/home", func(w http.ResponseWriter, r *http.Request) {
		handle([]Component{root, loggedIn, pageHome})(w, r)
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
