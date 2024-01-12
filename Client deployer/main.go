package main

import (
	"fmt"
	"math/rand"

	c "github.com/TwiN/go-color"
)

func RandomString() string {
	// generate a hexadecimal string of a given size
	const hex = "0123456789abcdef"
	buf := make([]byte, 16)
	for i := range buf {
		buf[i] = hex[rand.Intn(len(hex))]
	}
	return string(buf)
}

func main() {
	fmt.Println(c.InBold("\n  -- Mercury Setup Deployer --  \n"))

	id := RandomString()
	fmt.Println(c.InYellow("ID: ") + id)
}
