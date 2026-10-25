package ledger_test

import (
	"bytes"
	"reflect"
	"testing"
	"testing/iotest"

	. "Economy/ledger"
)

func sampleTransfer() Transfer {
	user := User{Id: "user"}
	unlimitedSrc := UnlimitedSource{Id: 1}
	limitedSrc := LimitedSource{Id: 2}
	pkgSrc := PackageSource{Id: 3}
	pkg := Package{Id: 3}
	unlimitedAsset := UnlimitedAsset{Id: 1}
	limitedAsset := LimitedAsset{Id: 2}
	currency := Currency{Id: 0}

	return Transfer{
		{
			Owner: user,
			Items: Items{
				One: ItemsOne{
					unlimitedAsset: {},
					unlimitedSrc:   {},
					limitedSrc:     {},
					pkgSrc:         {},
					pkg:            {},
					RandPlace():    {},
					RandGroup():    {},
				},
				Many: ItemsMany{
					currency:     100,
					limitedAsset: 5,
				},
			},
		},
		{
			Owner: pkgSrc,
			Items: Items{
				One: ItemsOne{
					pkg:            {},
					unlimitedAsset: {},
				},
				Many: ItemsMany{
					limitedAsset: 3,
				},
			},
		},
	}
}

func TestDeserialiseTransferFromPartialReads(t *testing.T) {
	original := sampleTransfer()

	buf := &bytes.Buffer{}
	if err := original.Serialise(buf); err != nil {
		t.Fatalf("Serialise: %v", err)
	}

	decoded, err := DeserialiseTransfer(iotest.OneByteReader(bytes.NewReader(buf.Bytes())))
	if err != nil {
		t.Fatalf("DeserialiseTransfer with partial reads: %v", err)
	}
	if !original.Equal(decoded) {
		t.Fatalf("expected %v, got %v", original, decoded)
	}
}

func TestDeserialiseItemsFromPartialReads(t *testing.T) {
	original := sampleTransfer()[0].Items

	buf := &bytes.Buffer{}
	if err := original.Serialise(buf); err != nil {
		t.Fatalf("Serialise: %v", err)
	}

	decoded, err := DeserialiseItems(iotest.OneByteReader(bytes.NewReader(buf.Bytes())))
	if err != nil {
		t.Fatalf("DeserialiseItems with partial reads: %v", err)
	}
	if !original.Equal(decoded) {
		t.Fatalf("expected %v, got %v", original, decoded)
	}
}

func TestDeserialiseOwnersFromPartialReads(t *testing.T) {
	one := OwnersOne{
		User{Id: "user"}:     {},
		PackageSource{Id: 3}: {},
		RandGroup():          {},
	}
	buf := &bytes.Buffer{}
	if err := one.Serialise(buf); err != nil {
		t.Fatalf("Serialise OwnersOne: %v", err)
	}
	decodedOne, err := DeserialiseOwnersOne(iotest.OneByteReader(bytes.NewReader(buf.Bytes())))
	if err != nil {
		t.Fatalf("DeserialiseOwnersOne with partial reads: %v", err)
	}
	if !reflect.DeepEqual(one, decodedOne) {
		t.Fatalf("expected %v, got %v", one, decodedOne)
	}

	many := OwnersMany{
		User{Id: "user"}:       5,
		UnlimitedSource{Id: 1}: 7,
	}
	buf = &bytes.Buffer{}
	if err := many.Serialise(buf); err != nil {
		t.Fatalf("Serialise OwnersMany: %v", err)
	}
	decodedMany, err := DeserialiseOwnersMany(iotest.OneByteReader(bytes.NewReader(buf.Bytes())))
	if err != nil {
		t.Fatalf("DeserialiseOwnersMany with partial reads: %v", err)
	}
	if !reflect.DeepEqual(many, decodedMany) {
		t.Fatalf("expected %v, got %v", many, decodedMany)
	}
}

func TestDeserialiseNumbersFromPartialReads(t *testing.T) {
	data := []byte{
		0, 0, 0, 5, // uint32
		0, 0, 0, 0, 0, 0, 0, 7, // uint64
	}
	reader := iotest.OneByteReader(bytes.NewReader(data))

	n32, err := DeserialiseUint32(reader)
	if err != nil {
		t.Fatalf("DeserialiseUint32 with partial reads: %v", err)
	}
	if n32 != 5 {
		t.Fatalf("expected 5, got %d", n32)
	}

	n64, err := DeserialiseUint64(reader)
	if err != nil {
		t.Fatalf("DeserialiseUint64 with partial reads: %v", err)
	}
	if n64 != 7 {
		t.Fatalf("expected 7, got %d", n64)
	}
}

func TestTruncatedTransferFails(t *testing.T) {
	buf := &bytes.Buffer{}
	if err := sampleTransfer().Serialise(buf); err != nil {
		t.Fatalf("Serialise: %v", err)
	}

	data := buf.Bytes()
	if _, err := DeserialiseTransfer(iotest.OneByteReader(bytes.NewReader(data[:len(data)-1]))); err == nil {
		t.Fatalf("expected a truncated transfer to fail")
	}
}
