package main

import (
	"fmt"
	"net/http"
)

var root = Component{
	Name: "root",
}

var loggedOut = Component{
	Name: "layouts/loggedout",
}

func loadindex(w http.ResponseWriter, r *http.Request, data Data) (Data, error) {
	return data, &ErrorRedirect{
		Path: "/login",
		Code: 302,
	}
}

var pageIndex = Component{
	Name:   "pages/index",
	Loader: loadindex,
}

var pageNotFound = Component{
	Name: "pages/404",
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

var login = Component{
	Name:   "pages/login",
	Loader: loadlogin,
}
