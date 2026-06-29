package main

import (
	"errors"

	"github.com/surrealdb/surrealdb.go/pkg/models"
)

const cookieName = "session"

var getSessionAndUserQuery = MustReadQuery("src/lib/server/getSessionAndUser")
var setSessionQuery = MustReadQuery("src/lib/server/setSession")

func createSession(user models.RecordID) (string, error) {
	qres, err := Query[any](setSessionQuery, map[string]any{
		"user": user,
	})
	if err != nil {
		return "", err
	}

	session, ok := qres[1].Result.(string)
	if !ok {
		return "", errors.New("invalid session token type")
	}
	return session, nil
}

type SessionValidationResult struct {
	Session *string `json:"session"`
	User    *User   `json:"user"`
}

func validateSessionToken(token string) (res SessionValidationResult, err error) {
	qres, err := Query[SessionValidationResult](getSessionAndUserQuery, map[string]any{
		"sess": models.NewRecordID("session", token),
	})
	if err != nil {
		return
	}

	if res = qres[3].Result; res.Session == nil || res.User == nil {
		return SessionValidationResult{}, nil
	}
	return
}
