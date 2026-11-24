package main

import (
	"bytes"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

// The committed client file has to match what the ledger generates now, so a change to ledger/types.go can't go unregenerated.
func TestClientTypesAreCurrent(t *testing.T) {
	want, err := Generate("../../ledger/types.go")
	if err != nil {
		t.Fatal(err)
	}

	got, err := os.ReadFile("../../client/types.gen.ts")
	if err != nil {
		t.Fatal(err)
	}

	if !bytes.Equal(got, want) {
		t.Error("client/types.gen.ts is out of date: run `go generate ./ledger` in Economy")
	}
}

// A method the generator doesn't recognise must fail generation, not be skipped.
func TestRejectsUnrecognisedCreate(t *testing.T) {
	const src = `package ledger

type (
	Type uint8
	Thing struct {
		Id uint32
	}
)

const (
	TypeNil Type = iota
	TypeThing
)

func (Thing) Type() Type { return TypeThing }
func (i Thing) ID() uint32 { return i.Id }
func (i Thing) String() string { return fmt.Sprintf("thing(%d)", i.Id) }
func (i Thing) Create() Thing { return i }
`

	path := filepath.Join(t.TempDir(), "types.go")

	if err := os.WriteFile(path, []byte(src), 0o644); err != nil {
		t.Fatal(err)
	}

	_, err := Generate(path)
	if err == nil || !strings.Contains(err.Error(), "Thing.Create") {
		t.Fatalf("want an error naming Thing.Create, got %v", err)
	}
}
