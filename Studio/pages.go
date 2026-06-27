package main

import (
	"crypto/subtle"
	"encoding/base64"
	"errors"
	"fmt"
	"net/http"
	"strings"

	"github.com/surrealdb/surrealdb.go/pkg/models"
	"golang.org/x/crypto/argon2"
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

func MakeInputResponse(value string) InputResponse {
	return InputResponse{
		Value:  value,
		Errors: make([]string, 0),
	}
}

var setSessionQuery = MustReadQuery("src/lib/server/setSession")

func createSession(user models.RecordID) (string, error) {
	qres, err := Query[[]string](setSessionQuery, map[string]any{
		"user": user,
	})
	if err != nil {
		return "", err
	}
	session := qres[0].Result[0]
	return session, nil
}

var (
	ErrInvalidHash         = errors.New("invalid password hash")
	ErrIncompatibleVersion = errors.New("incompatible password hash version")
)

type params struct {
	memory      uint32
	iterations  uint32
	parallelism uint8
	saltLength  uint32
	keyLength   uint32
}

func decodeHash(encodedHash string) (p *params, salt, hash []byte, err error) {
	vals := strings.Split(encodedHash, "$")
	if len(vals) != 6 {
		return nil, nil, nil, ErrInvalidHash
	}

	var version int
	if _, err = fmt.Sscanf(vals[2], "v=%d", &version); err != nil {
		return nil, nil, nil, fmt.Errorf("parse version: %w", err)
	}

	if version != argon2.Version {
		return nil, nil, nil, ErrIncompatibleVersion
	}

	p = &params{}

	if _, err = fmt.Sscanf(vals[3], "m=%d,t=%d,p=%d", &p.memory, &p.iterations, &p.parallelism); err != nil {
		return nil, nil, nil, fmt.Errorf("parse parameters: %w", err)
	}

	if salt, err = base64.RawStdEncoding.Strict().DecodeString(vals[4]); err != nil {
		return nil, nil, nil, fmt.Errorf("decode salt: %w", err)
	}
	p.saltLength = uint32(len(salt))

	if hash, err = base64.RawStdEncoding.Strict().DecodeString(vals[5]); err != nil {
		return nil, nil, nil, fmt.Errorf("decode hash: %w", err)
	}
	p.keyLength = uint32(len(hash))

	return p, salt, hash, nil
}

func verifyPassword(password, encodedHash string) (match bool, err error) {
	// Extract the parameters, salt and derived key from the encoded password
	// hash.
	p, salt, hash, err := decodeHash(encodedHash)
	if err != nil {
		return false, err
	}

	// Derive the key from the other password using the same parameters.
	otherHash := argon2.IDKey([]byte(password), salt, p.iterations, p.memory, p.parallelism, p.keyLength)

	// prevent timing attacks
	return subtle.ConstantTimeCompare(hash, otherHash) == 1, nil
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

	type AuthUser = struct {
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
	fmt.Println("success!")
	return d, nil
}

var pageLogin = Component{
	Name:   "pages/login",
	Loader: loadlogin,
}

var pageHome = Component{
	Name: "pages/home",
}
