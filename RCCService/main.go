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

func Log(a ...any) {
	a = append([]any{time.Now().Format("01/02/2006, 15:04:05 ")}, a...)
	fmt.Println(a...)
}

func StartRCC() {
	if _, err := os.Stat("./RCCService/RCCService.exe"); os.IsNotExist(err) {
		Log(c.InRed("RCCService not found!"))
		os.Exit(1)
	}
	for {
		cmd := exec.Command("./RCCService/RCCService.exe", "-Console")
		cmd.Run()

		Log(c.InRed("RCCService has stopped. Restarting..."))
	}
}

func main() {
	Log(c.InYellow("Loading environment variables..."))
	err := env.Load(".env")
	if err != nil {
		panic(err)
	}

	Log(c.InYellow("Loading XML template..."))
	soap, err := os.ReadFile("soap.xml")
	if err != nil {
		panic(err)
	}
	template := string(soap)

	Log(c.InPurple("Starting RCCService..."))
	go StartRCC()

	Log(c.InPurple("Starting server..."))
	gin.SetMode(gin.ReleaseMode)
	r := gin.New()
	r.Use(gin.Recovery())
	r.SetTrustedProxies([]string{"127.0.0.1"})

	r.POST("/:id", func(c *gin.Context) {
		ip := c.ClientIP()
		if ip != os.Getenv("IP") && ip != "::1" {
			Log("IP " + ip + " is not allowed")
			c.AbortWithStatus(http.StatusForbidden)
			return
		}

		renderScript, err := io.ReadAll(c.Request.Body)
		if err != nil {
			panic(err)
		}

		currentTemplate := strings.ReplaceAll(template, "_TASK_ID", c.Param("id"))
		currentTemplate = strings.ReplaceAll(currentTemplate, "_RENDER_SCRIPT", string(renderScript))

		client := &http.Client{}
		req, err := http.NewRequest("POST", "http://localhost:64989", strings.NewReader(currentTemplate))
		if err != nil {
			panic(err)
		}
		req.Header.Set("Content-Type", "text/xml; charset=utf-8")
		req.Header.Set("SOAPAction", "http://roblox.com/OpenJobEx")

		client.Do(req)

		c.String(200, "OK")
	})

	Log(c.InGreen("~ RCCService is up on port 64990 ~"))
	Log(c.InGreen("Send a POST request to /{your task id} with the render script as the body to start a render"))
	r.Run("0.0.0.0:64990")
}
