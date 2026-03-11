package main

import (
	"context"
	"fmt"
	"os"

	"github.com/surrealdb/surrealdb.go"
)

var (
	ctx = context.Background()
	db  *surrealdb.Session
)

func MustReadQuery(path string) string {
	data, err := os.ReadFile("../Site/" + path + ".surql")
	if err != nil {
		panic(fmt.Sprintf("Failed to read file: %s", path))
	}

	return string(data)
}

func Query[TResult any](sql string, vars map[string]any) ([]surrealdb.QueryResult[TResult], error) {
	q, err := surrealdb.Query[TResult](ctx, db, sql, vars)
	if err != nil {
		return nil, err
	}

	return *q, nil
}

var initQuery = MustReadQuery("src/lib/server/init")

func init() {
	database, err := surrealdb.FromEndpointURLString(ctx, "ws://localhost:8000")
	if err != nil {
		fmt.Println("Failed to connect to SurrealDB")
		panic(err)
	}

	if db, err = database.Attach(ctx); err != nil {
		fmt.Println("Failed to attach to database")
		panic(err)
	}

	authData := surrealdb.Auth{
		Username: "root",
		Password: "root",
	}

	if _, err := db.SignIn(ctx, authData); err != nil {
		fmt.Println("Failed to sign in to database")
		panic(err)
	}

	if err := db.Use(ctx, "main", "main"); err != nil {
		fmt.Println("Failed to select namespace and database")
		panic(err)
	}

	if _, err := Query[any](initQuery, nil); err != nil {
		fmt.Println("Failed to run init query")
		panic(err)
	}

	fmt.Println("Database successfully connected")
}
