package main

import (
	"fmt"
	"net/http"

	"github.com/surrealdb/surrealdb.go/pkg/models"
)

func loadroot(w http.ResponseWriter, r *http.Request, d Data) (Data, error) {
	token, err := r.Cookie(cookieName)
	if err != nil {
		if err == http.ErrNoCookie {
			return d, nil
		}
		return d, fmt.Errorf("get cookie: %w", err)
	}

	res, err := validateSessionToken(token.Value)
	if err != nil {
		return d, fmt.Errorf("validate session token: %w", err)
	}

	d.Session = res.Session
	d.User = res.User

	return d, nil
}

var root = Component{
	Name:   "root",
	Loader: loadroot,
}

func loadloggedIn(w http.ResponseWriter, r *http.Request, d Data) (Data, error) {
	if d.User == nil {
		return d, &ErrorRedirect{
			Path: "/login",
			Code: 302,
		}
	}

	return d, nil
}

var loggedIn = Component{
	Name:   "layouts/loggedin",
	Loader: loadloggedIn,
}

func loadloggedOut(w http.ResponseWriter, r *http.Request, d Data) (Data, error) {
	if d.User != nil {
		return d, &ErrorRedirect{
			Path: "/home",
			Code: 302,
		}
	}

	return d, nil
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

func MakeInputResponse(value string) InputResponse {
	return InputResponse{
		Value:  value,
		Errors: make([]string, 0),
	}
}

var login_userQuery = MustReadQuery("src/routes/(plain)/login/user")

func loadlogin(w http.ResponseWriter, r *http.Request, d Data) (Data, error) {
	if r.Method != "POST" {
		return d, nil
	}

	if err := r.ParseForm(); err != nil {
		return d, fmt.Errorf("parse form: %w", err)
	}

	username := r.Form.Get("username")
	password := r.Form.Get("password")

	rUsername := MakeInputResponse(username)
	rPassword := MakeInputResponse(password)

	// if len(password) < 16 {
	// 	rUsername.Errors = append(rUsername.Errors, "")
	// 	rPassword.Errors = append(rPassword.Errors, "Incorrect username or password")

	// 	d.Data["username"] = rUsername
	// 	d.Data["password"] = rPassword
	// 	return d, nil
	// }

	type AuthUser struct {
		ID             models.RecordID `json:"id"`
		HashedPassword string          `json:"hashedPassword"`
	}

	qres, err := Query[[]AuthUser](login_userQuery, map[string]any{
		"username": username,
	})
	if err != nil {
		return d, fmt.Errorf("query user: %w", err)
	}

	res := qres[0].Result
	if len(res) == 0 {
		rUsername.Errors = append(rUsername.Errors, "")
		rPassword.Errors = append(rPassword.Errors, "Incorrect username or password")

		d.Data["username"] = rUsername
		d.Data["password"] = rPassword
		return d, nil
	}

	user := res[0]

	match, err := verifyPassword(password, user.HashedPassword)
	if err != nil {
		return d, fmt.Errorf("verify password: %w", err)
	}

	if !match {
		rUsername.Errors = append(rUsername.Errors, "")
		rPassword.Errors = append(rPassword.Errors, "Incorrect username or password")

		d.Data["username"] = rUsername
		d.Data["password"] = rPassword
		return d, nil
	}

	// todo: cookie time
	// fmt.Println("success!")
	session, err := createSession(user.ID)
	if err != nil {
		return d, fmt.Errorf("create session: %w", err)
	}

	http.SetCookie(w, &http.Cookie{
		Name:   cookieName,
		Value:  session,
		MaxAge: 30 * 24 * 60 * 60, // 30 days
		Path:   "/",
	})

	return d, nil
}

var pageLogin = Component{
	Name:   "pages/login",
	Loader: loadlogin,
}

func loadlogout(w http.ResponseWriter, r *http.Request, d Data) (Data, error) {
	http.SetCookie(w, &http.Cookie{
		Name:   cookieName,
		Value:  "",
		MaxAge: -1,
	})

	return d, &ErrorRedirect{
		Path: "/login",
		Code: 302,
	}
}

var pageLogout = Component{
	Name: "pages/logout",
	Loader: loadlogout,
}

var pageHome = Component{
	Name: "pages/home",
}
