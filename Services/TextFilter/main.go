package main

import (
	"fmt"
	"net/http"
	"os"

	c "github.com/TwiN/go-color"
)

func Assert(err error, txt string) {
	// so that I don't have to write this every time
	if err != nil {
		fmt.Println(c.InRed(txt+": ") + err.Error())
		os.Exit(1)
	}
}

func main() {
	InitCommentAnalyzer()

	http.HandleFunc("/v1/get-text-filtered", GetTextFilteredRoute)
	http.HandleFunc("/v1/get-text-filtered-unstable", GetTextFilteredUnstableRoute)

	fmt.Println(c.InGreen("~ TextFilter service is up on port 3476 ~"))
	err := http.ListenAndServe(":3476", nil)
	Assert(err, "Failed to start server")
}
