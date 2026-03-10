package main

import (
	"context"
	"fmt"

	"github.com/surrealdb/surrealdb.go"
)

var db *surrealdb.DB

func init() {
	ctx := context.Background()

	var err error
	if db, err = surrealdb.FromEndpointURLString(ctx, "ws://localhost:8000"); err != nil {
		fmt.Println("Failed to connect to SurrealDB")
		panic(err)
	}

	if err := db.Use(ctx, "main", "main"); err != nil {
		fmt.Println("Failed to use namespace and database")
		panic(err)
	}

	authData := &surrealdb.Auth{
		Username: "root",
		Password: "root",
	}

	if _, err := db.SignIn(ctx, authData); err != nil {
		fmt.Println("Failed to sign in to database")
		panic(err)
	}

	fmt.Println("Database successfully connected")
}
