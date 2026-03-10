package main

import "net/http"

func loadnone(w http.ResponseWriter, r *http.Request, data Data) (Data, error) {
	return data, nil
}

var root = Component{
	Name:   "root",
	Loader: loadnone,
}

var loggedOut = Component{
	Name:   "layouts/loggedout",
	Loader: loadnone,
}

func loadindex(w http.ResponseWriter, r *http.Request, data Data) (Data, error) {
	return data, &ErrorRedirect{
		Path:  "/login",
		Code: 302,
	}
}

var pageIndex = Component{
	Name:   "pages/index",
	Loader: loadindex,
}

var pageNotFound = Component{
	Name:   "pages/404",
	Loader: loadnone,
}

func loadlogin(w http.ResponseWriter, r *http.Request, data Data) (Data, error) {
	if r.Method != "POST" {
		return data, nil
	}

	return data, nil
}

var login = Component{
	Name:   "pages/login",
	Loader: loadlogin,
}
