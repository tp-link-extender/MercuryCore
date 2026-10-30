package ledger_test

import (
	"bytes"
	"encoding/binary"
	"io"
	"strings"
	"testing"

	. "Economy/ledger"
)

func TestCollectionLengthLimits(t *testing.T) {
	cases := []struct {
		name string
		read func(io.Reader) error
	}{
		{
			name: "ItemsOne",
			read: func(r io.Reader) error {
				_, err := DeserialiseItemsOne(r)
				return err
			},
		},
		{
			name: "ItemsMany",
			read: func(r io.Reader) error {
				_, err := DeserialiseItemsMany(r)
				return err
			},
		},
		{
			name: "OwnersOne",
			read: func(r io.Reader) error {
				_, err := DeserialiseOwnersOne(r)
				return err
			},
		},
		{
			name: "OwnersMany",
			read: func(r io.Reader) error {
				_, err := DeserialiseOwnersMany(r)
				return err
			},
		},
	}

	var lenBuf [4]byte
	binary.BigEndian.PutUint32(lenBuf[:], uint32(MaxCollectionEntries)+1)

	for _, c := range cases {
		t.Run(c.name, func(t *testing.T) {
			err := c.read(bytes.NewReader(lenBuf[:]))
			if err == nil {
				t.Fatalf("expected an oversized %s length to be rejected", c.name)
			}
			if !strings.Contains(err.Error(), "exceeds limit") {
				t.Fatalf("expected a limit error, got %v", err)
			}
		})
	}
}
