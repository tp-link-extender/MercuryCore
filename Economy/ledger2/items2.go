package main

import (
	"fmt"
	"strings"
)

type ItemsOne map[CanOwnOne]struct{}

func (i ItemsOne) String() string {
	parts := make([]string, 0, len(i))
	for id := range i {
		parts = append(parts, id.String())
	}
	return "{" + strings.Join(parts, ", ") + "}"
}

func (i ItemsOne) Equal(other ItemsOne) bool {
	if len(i) != len(other) {
		return false
	}

	for id := range i {
		if _, ok := other[id]; !ok {
			return false
		}
	}

	return true
}

type (
	Quantity  uint64
	ItemsMany map[CanOwnMany]Quantity
)

func (i ItemsMany) String() string {
	parts := make([]string, 0, len(i))
	for id, qty := range i {
		parts = append(parts, fmt.Sprintf("%s: %d", id.String(), qty))
	}
	return "{" + strings.Join(parts, ", ") + "}"
}

func (i ItemsMany) Equal(other ItemsMany) bool {
	if len(i) != len(other) {
		return false
	}

	for id := range i {
		if qty, ok := other[id]; !ok || qty != i[id] {
			return false
		}
	}

	return true
}

type Items struct {
	One  ItemsOne
	Many ItemsMany
}

func (i Items) String() string {
	return fmt.Sprintf("Items{\n\t One: %s,\n\tMany: %s\n}", i.One.String(), i.Many.String())
}

func (i Items) Equal(other Items) bool {
	return i.One.Equal(other.One) && i.Many.Equal(other.Many)
}
