package main

import (
	"crypto/subtle"
	"encoding/base64"
	"errors"
	"fmt"
	"strings"

	"golang.org/x/crypto/argon2"
)

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
