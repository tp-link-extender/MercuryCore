// "GO?
// WHY THE FUCK
// IS THIS IN GO?
// ARE YOU STUPID
// ???"
// - taskmanager, 9 January 2024

// cope harder

package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"os/exec"
	"strings"
	"time"

	c "github.com/TwiN/go-color"
	"github.com/gin-gonic/gin"
	env "github.com/joho/godotenv"
)

var client http.Client

func Log(txt string) {
	// I HATE GO DATE FORMATTING!!! I HATE GO DATE FORMATTING!!!
	fmt.Println(time.Now().Format("02/01/2006, 15:04:05 "), txt)
}

func Assert(err error, txt string) {
	// so that I don't have to write this every time
	if err != nil {
		fmt.Println(err)
		Log(c.InRed(txt))
		os.Exit(1)
	}
}

func StartRCC() {
	_, err := os.Stat("./RCCService/RCCService.exe")
	Assert(err, "RCCService.exe not found! Please place the RCCService folder in the current directory.")
	for {
		exec.Command("./RCCService/RCCService.exe", "-Console").Run()
		Log(c.InRed("RCCService has stopped. Restarting..."))
	}
}

func main() {
	Log(c.InYellow("Loading environment variables..."))
	err := env.Load(".env")
	Assert(err, "Failed to load environment variables. Please place them in a .env file in the current directory.")

	Log(c.InYellow("Loading XML template..."))
	soap, err := os.ReadFile("soap.xml")
	Assert(err, "Failed to read soap.xml")
	template := string(soap)

	Log(c.InPurple("Starting RCCService..."))
	go StartRCC()

	Log(c.InPurple("Starting server..."))
	gin.SetMode(gin.ReleaseMode)
	r := gin.New()
	r.Use(gin.Recovery())
	r.SetTrustedProxies([]string{"127.0.0.1"})

	r.POST("/:id", func(cx *gin.Context) {
		if ip := cx.ClientIP(); ip != os.Getenv("IP") && ip != "::1" {
			Log(c.InRed("IP " + ip + " is not allowed!"))
			cx.AbortWithStatus(http.StatusForbidden)
			return
		}

		renderScript, err := io.ReadAll(cx.Request.Body)
		Assert(err, "Failed to read render script")

		id := cx.Param("id")
		currentTemplate := strings.ReplaceAll(template, "_TASK_ID", id)
		currentTemplate = strings.ReplaceAll(currentTemplate, "_RENDER_SCRIPT", string(renderScript))

		req, err := http.NewRequest("POST", "http://localhost:64989", strings.NewReader(currentTemplate))
		Assert(err, "Failed to create request")

		req.Header.Set("Content-Type", "text/xml; charset=utf-8")
		req.Header.Set("SOAPAction", "http://roblox.com/OpenJobEx")

		Log(c.InBlue("Rendering " + id))
		client.Do(req)

		cx.String(200, "OK")
	})

	Log(c.InGreen("~ RCCService is up on port 64990 ~"))
	Log(c.InGreen("Send a POST request to /{your task id} with the render script as the body to start a render"))
	r.Run("0.0.0.0:64990")
}
