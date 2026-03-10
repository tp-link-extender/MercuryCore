package main

import (
	"fmt"
	"net/http"
)

func loadroot(w http.ResponseWriter, r *http.Request, d Data) (Data, error) {
	return d, nil
}

var root = Component{
	Name:   "root",
	Loader: loadroot,
}

func loadloggedIn(w http.ResponseWriter, r *http.Request, d Data) (Data, error) {
	if d.User != nil {
		return d, nil
	}

	return d, &ErrorRedirect{
		Path: "/login",
		Code: 302,
	}
}

var loggedIn = Component{
	Name:   "layouts/loggedin",
	Loader: loadloggedIn,
}

func loadloggedOut(w http.ResponseWriter, r *http.Request, d Data) (Data, error) {
	if d.User == nil {
		return d, nil
	}

	return d, &ErrorRedirect{
		Path: "/home",
		Code: 302,
	}
}

var loggedOut = Component{
	Name:   "layouts/loggedout",
	Loader: loadloggedOut,
}

var pageNotFound = Component{
	Name: "pages/404",
}

func loadindex(w http.ResponseWriter, r *http.Request, d Data) (Data, error) {
	if d.User != nil {
		return d, &ErrorRedirect{
			Path: "/home",
			Code: 302,
		}
	}

	return d, &ErrorRedirect{
		Path: "/login",
		Code: 302,
	}
}

var pageIndex = Component{
	Loader: loadindex,
}

type InputResponse struct {
	Value  string
	Errors []string
}

func MakeInputResponse() InputResponse {
	return InputResponse{
		Errors: make([]string, 0),
	}
}

func loadlogin(w http.ResponseWriter, r *http.Request, d Data) (Data, error) {
	if r.Method != "POST" {
		return d, nil
	}

	if err := r.ParseForm(); err != nil {
		return d, fmt.Errorf("parse form: %w", err)
	}

	username := r.Form.Get("username")
	password := r.Form.Get("password")
	fmt.Println(username, password)

	rUsername := MakeInputResponse()
	rPassword := MakeInputResponse()

	if len(password) < 16 {
		rUsername.Errors = append(rUsername.Errors, "")
		rPassword.Errors = append(rPassword.Errors, "Incorrect username or password")
	}

	rUsername.Value = username
	rPassword.Value = password

	d.Data["username"] = rUsername
	d.Data["password"] = rPassword
	return d, nil
}

var pageLogin = Component{
	Name:   "pages/login",
	Loader: loadlogin,
}

var pageHome = Component{
	Name: "pages/home",
}
