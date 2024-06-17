// "GO?
// WHY THE FUCK
// IS THIS IN GO?
// ARE YOU STUPID
// ???"
// - taskmanager, 9 January 2024

// cope harder

package main

import (
	"compress/gzip"
	"encoding/base64"
	"fmt"
	"io"
	"net/http"
	"os"
	"os/exec"
	"strings"
	"sync"
	"time"

	c "github.com/TwiN/go-color"
	"github.com/disintegration/imaging"
	env "github.com/joho/godotenv"
)

var (
	wg     sync.WaitGroup
	client http.Client
)

func Log(txt string) {
	// I HATE GO DATE FORMATTING!!! I HATE GO DATE FORMATTING!!!
	fmt.Println(time.Now().Format("2006/01/02, 15:04:05 "), txt)
}

func Logr(txt string) {
	fmt.Print("\r", time.Now().Format("2006/01/02, 15:04:05  "), txt)
}

func Assert(err error, txt string) {
	// so that I don't have to write this every time
	// todo: should only be used for fatal errors
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

func TestRCCStarted(loaded *bool, t int) {
	Logr(c.InPurple(fmt.Sprintf("Waiting for RCCService to start... (%ds)", t)))
	_, err := http.Get("http://localhost:64989")
	if err == nil {
		*loaded = true
	}
}

func Compress(b64 string, resolution int, name string, compressed *string) {
	data, err := base64.StdEncoding.DecodeString(b64)
	Assert(err, "Failed to decode base64 of image")

	srcimg, err := imaging.Decode(strings.NewReader(string(data)))
	Assert(err, "Failed to decode image from data")

	// Lanczos my beloved 💖 (change it to something faster idc)
	img := imaging.Resize(srcimg, resolution, resolution, imaging.Lanczos)
	Assert(err, "Failed to create image from data")

	writer := new(strings.Builder)
	imaging.Encode(writer, img, imaging.PNG)

	*compressed = base64.StdEncoding.EncodeToString([]byte(writer.String()))

	wg.Done()
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

	loaded := false
	for startTime := time.Now(); !loaded; time.Sleep(100 * time.Millisecond) {
		go TestRCCStarted(&loaded, int(time.Since(startTime).Seconds()))
	}

	fmt.Println()
	Log(c.InPurple("Starting server..."))

	router := http.NewServeMux()

	router.HandleFunc("POST /{id}", func(w http.ResponseWriter, r *http.Request) {
		// remove port from IP (can't just split by ":" because of IPv6)
		if ip := r.RemoteAddr[:strings.LastIndex(r.RemoteAddr, ":")]; ip != os.Getenv("IP") && ip != "[::1]" {
			Log(c.InRed("IP " + ip + " is not allowed! (render)"))
			w.WriteHeader(http.StatusForbidden)
			return
		}

		loadScript, err := io.ReadAll(r.Body)
		Assert(err, "Failed to read render script")

		script := strings.ReplaceAll(string(loadScript), "_PING_URL", "http://localhost:64990/ping")

		id := r.PathValue("id")
		currentTemplate := strings.ReplaceAll(template, "_TASK_ID", id)
		currentTemplate = strings.ReplaceAll(currentTemplate, "_RENDER_SCRIPT", script)

		req, err := http.NewRequest("POST", "http://localhost:64989", strings.NewReader(currentTemplate))
		Assert(err, "Failed to create request")

		req.Header.Set("Content-Type", "text/xml; charset=utf-8")
		req.Header.Set("SOAPAction", "http://roblox.com/OpenJobEx")

		Log(c.InBlue("Sending request to render " + id))
		client.Do(req)

		w.WriteHeader(http.StatusOK)
	})

	router.HandleFunc("POST /ping/{id}", func(w http.ResponseWriter, r *http.Request) {
		// remove port from IP (can't just split by ":" because of IPv6)
		if ip := r.RemoteAddr[:strings.LastIndex(r.RemoteAddr, ":")]; ip != "[::1]" {
			Log(c.InRed("IP " + ip + " is not allowed! (ping)"))
			w.WriteHeader(http.StatusForbidden)
			return
		}

		apiKey := r.URL.Query().Get("apiKey")
		id := r.PathValue("id")

		readBody, err := io.ReadAll(r.Body)
		Assert(err, "Failed to read request body")

		// if the body is gzipped, unzip it
		if strings.HasPrefix(string(readBody), "\x1f\x8b") {
			reader, err := gzip.NewReader(strings.NewReader(string(readBody)))
			Assert(err, "Failed to create gzip reader")
			readBody, err = io.ReadAll(reader)
			Assert(err, "Failed to read gzipped request body")
		}

		data := strings.Split(string(readBody), "\n")
		status := data[0]

		var compressed []string

		switch status {
		case "Rendering":
			Log(c.InGreen("Render " + id + " is rendering"))
		case "Completed":
			num := len(data) - 1
			wg.Add(num)

			// Could result in a random order if appending to an array instead
			var body, head string
			go Compress(data[1], 420, "body", &body)
			if num == 2 {
				go Compress(data[2], 150, "head", &head)
			}
			wg.Wait()

			compressed = []string{body}
			if num == 2 {
				compressed = append(compressed, head)
			}

			Log(c.InGreen("Render " + id + " is complete"))
		}

		compressed = append([]string{status}, compressed...)

		// Send to server as base64
		// todo make it multipart/form-data or something for lower bandwidth
		endpoint := fmt.Sprintf("%s/%s?apiKey=%s", os.Getenv("ENDPOINT"), id, apiKey)
		// We (still) have to lie about the contentType to avoid being nuked by CORS from the website
		_, err = http.Post(endpoint, "text/json", strings.NewReader(strings.Join(compressed, "\n")))
		Assert(err, "Failed to send render data to server")

		w.WriteHeader(http.StatusOK)
	})

	Log(c.InGreen("~ RCCService is up on port 64990 ~"))
	Log(c.InGreen("Send a POST request to /{your task id} with the render script as the body to start a render"))
	http.ListenAndServe(":64990", router)
}
