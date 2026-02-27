package main

import "net/http"

func loadnone(w http.ResponseWriter, r *http.Request) (Data, error) {
	return Data{}, nil
}

var root = Component{
	Name:   "root",
	Loader: loadnone,
}

var loggedOut = Component{
	Name:   "layouts/loggedout",
	Loader: loadnone,
}

var pageIndex = Component{
	Name:   "pages/index",
	Loader: loadnone,
}

var pageNotFound = Component{
	Name:   "pages/404",
	Loader: loadnone,
}
