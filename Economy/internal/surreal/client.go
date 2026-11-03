package surreal

import (
	"context"
	"fmt"

	surrealdb "github.com/surrealdb/surrealdb.go"
)

// Client is a small wrapper around the official SurrealDB Go SDK for the administrative commands in this repository.
type Client struct {
	ctx context.Context
	db  *surrealdb.DB
}

func New(url, namespace, database, user, pass string) (*Client, error) {
	ctx := context.Background()
	db, err := surrealdb.FromEndpointURLString(ctx, url)
	if err != nil {
		return nil, fmt.Errorf("connect surreal: %w", err)
	}
	if err := db.Use(ctx, namespace, database); err != nil {
		db.Close(ctx)
		return nil, fmt.Errorf("use surreal namespace/database: %w", err)
	}
	if _, err := db.SignIn(ctx, surrealdb.Auth{Username: user, Password: pass}); err != nil {
		db.Close(ctx)
		return nil, fmt.Errorf("sign in to surreal: %w", err)
	}
	return &Client{ctx: ctx, db: db}, nil
}

func (c *Client) Close() error {
	return c.db.Close(c.ctx)
}

// Query runs a single-statement query and returns its typed rows.
func Query[T any](c *Client, sql string, vars map[string]any) ([]T, error) {
	results, err := surrealdb.Query[[]T](c.ctx, c.db, sql, vars)
	if err != nil {
		return nil, err
	}
	if results == nil || len(*results) != 1 {
		n := 0
		if results != nil {
			n = len(*results)
		}
		return nil, fmt.Errorf("surreal returned %d statement results, expected 1", n)
	}

	qr := (*results)[0]
	if qr.Error != nil {
		return nil, fmt.Errorf("surreal query failed: %w", qr.Error)
	}
	if qr.Status != "OK" {
		return nil, fmt.Errorf("surreal query status %q: %v", qr.Status, qr.Result)
	}
	return qr.Result, nil
}

// QueryOne runs a single-statement query and returns its single object result.
func QueryOne[T any](c *Client, sql string, vars map[string]any) (T, error) {
	var zero T
	results, err := surrealdb.Query[T](c.ctx, c.db, sql, vars)
	if err != nil {
		return zero, err
	}
	if results == nil || len(*results) != 1 {
		n := 0
		if results != nil {
			n = len(*results)
		}
		return zero, fmt.Errorf("surreal returned %d statement results, expected 1", n)
	}

	qr := (*results)[0]
	if qr.Error != nil {
		return zero, fmt.Errorf("surreal query failed: %w", qr.Error)
	}
	if qr.Status != "OK" {
		return zero, fmt.Errorf("surreal query status %q: %v", qr.Status, qr.Result)
	}
	return qr.Result, nil
}

// Exec runs a multi-statement script, such as a transaction, and checks every statement result.
// Any error aborts the caller before it treats the script as successful.
func Exec(c *Client, sql string, vars map[string]any) error {
	results, err := surrealdb.Query[any](c.ctx, c.db, sql, vars)
	if err != nil {
		return err
	}
	if results == nil || len(*results) == 0 {
		return fmt.Errorf("surreal returned no statement results")
	}
	for i, qr := range *results {
		if qr.Error != nil {
			return fmt.Errorf("statement %d: %w", i, qr.Error)
		}
		if qr.Status != "OK" {
			return fmt.Errorf("statement %d: status %q: %v", i, qr.Status, qr.Result)
		}
	}
	return nil
}
