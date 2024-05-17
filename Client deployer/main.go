// Mercury Setup Deployer 3, now in Go
// goroutines make it run fast as FUCK

package main

import (
	"archive/zip"
	"fmt"
	"io"
	"os"
	"path"
	"path/filepath"
	"strings"
	"sync"
	"time"

	c "github.com/TwiN/go-color"
	fileversion "github.com/bi-zone/go-fileversion"
)

func Assert(err error, txt string) {
	// so that I don't have to write this every time
	// if this was Luau it would probably be worse for performance
	if err != nil {
		fmt.Println(c.InRed("Error: ") + txt)
		os.Exit(1)
	}
}

type Task struct {
	name      string
	endMillis int64
}

// For epic logging
var (
	list        = []Task{}
	timeStart   = time.Now()
	startMillis = timeStart.UnixMilli()
	// To wait for all main goroutines to finish
	wg sync.WaitGroup
)

var tasks = []string{
	"version.txt",
	"MercuryPlayerLauncher.exe",
	"redist.zip",
	"Mercury.zip",
	"Libraries.zip",
	"content-textures.zip",
	"content-textures2.zip",
	"content-textures3.zip",
	"content-sky.zip",
	"content-fonts.zip",
	"content-music.zip",
	"content-sounds.zip",
	"content-particles.zip",
	"BuiltInPlugins.zip",
	"imageformats.zip",
	"shaders.zip",
}

func UpdateTasks() {
	// Clear last printed tasks
	toPrint := fmt.Sprintf("\033[%dA", len(list))

	// Print all tasks, with "Done! ({x}ms)" at the end if they are completed
	for _, task := range list {
		spaces := 30 - len(task.name)
		toPrint += c.InBlue("Creating " + c.InUnderline(task.name))
		if task.endMillis > 0 {
			toPrint += strings.Repeat(" ", spaces) + c.InBlackOverGreen(fmt.Sprintf(" Done! (%dms) ", task.endMillis-startMillis))
		}
		toPrint += "\n"
	}

	fmt.Print(toPrint)
}

func CompleteTask(completedTask string) {
	for i, task := range list {
		if task.name == completedTask {
			list[i].endMillis = time.Now().UnixMilli()
		}
	}
	UpdateTasks()
	wg.Done()
}

func WriteFile(writer *zip.Writer, pathName string, entryName string) {
	file, err := os.Open(pathName)
	Assert(err, "Could not read file "+pathName)
	defer file.Close()

	entry, err := writer.Create(entryName)
	Assert(err, "Could not create zip entry "+entryName)

	_, err = io.Copy(entry, file)
	Assert(err, "Could not copy file "+pathName+" to zip entry "+entryName)
}

func WriteFolder(writer *zip.Writer, pathName string, entryName string) {
	files, err := os.ReadDir(pathName)
	Assert(err, "Could not read directory "+pathName)

	var newEntry string
	if len(entryName) > 0 {
		newEntry = entryName + "/"
	}

	// Write files to zip entry
	for _, file := range files {
		if file.IsDir() {
			WriteFolder(writer, path.Join(pathName, file.Name()), newEntry+file.Name())
		} else {
			WriteFile(writer, path.Join(pathName, file.Name()), newEntry+file.Name())
		}
	}
}

func ZipFromArray(destination string, sources []string, baseDirectory string, isFolder bool) {
	defer CompleteTask(destination)
	destination = filepath.Join("PrepForUpload", destination)

	zipFile, err := os.Create(destination)
	Assert(err, "Could not create zip file "+destination)
	defer zipFile.Close()

	archive := zip.NewWriter(zipFile)
	defer archive.Close()
	var entryName string

	for _, file := range sources {
		if len(baseDirectory) > 0 {
			entryName = strings.TrimPrefix(file, baseDirectory)
		} else {
			entryParts := strings.Split(file, "/")
			entryName = entryParts[len(entryParts)-1]
		}

		pathName := path.Join("staging", baseDirectory, file)
		if entryName == "ui" {
			WriteFolder(archive, pathName, "ui")
		} else if isFolder {
			WriteFolder(archive, pathName, baseDirectory+file)
		} else {
			WriteFile(archive, pathName, file)
		}
	}
}

func ZipFromFolder(destination string, source string) {
	defer CompleteTask(destination)
	destination = filepath.Join("PrepForUpload", destination)

	zipFile, err := os.Create(destination)
	Assert(err, "Could not create zip file "+destination)
	defer zipFile.Close()

	archive := zip.NewWriter(zipFile)
	defer archive.Close()

	WriteFolder(archive, filepath.Join("staging", source), "")
}

func UpdateVersion(task string, newVersion string) {
	defer CompleteTask(task)
	// Update version.txt with the new version
	versionFile, err := os.Create(filepath.Join("setup", "version.txt"))
	Assert(err, "Could not create version.txt")
	defer versionFile.Close()
	fmt.Fprint(versionFile, newVersion)
}

func CopyLauncher(task string) {
	defer CompleteTask(task)
	// Copy MercuryPlayerLauncher.exe to setup
	launcher, err := os.Open(filepath.Join("staging", task))
	Assert(err, "Could not read MercuryPlayerLauncher.exe")
	defer launcher.Close()

	destination1, err := os.Create(filepath.Join("setup", task))
	Assert(err, "Could not create MercuryPlayerLauncher.exe (1)")
	destination2, err := os.Create(filepath.Join("PrepForUpload", task))
	Assert(err, "Could not create MercuryPlayerLauncher.exe (2)")
	defer destination1.Close()
	defer destination2.Close()

	fv, err := fileversion.New(filepath.Join("staging", "MercuryPlayerLauncher.exe"))
	Assert(err, "Could not get file version of MercuryPlayerLauncher.exe")
	fileVersion := fv.FileVersion()

	// Write version to MercuryVersion.txt
	versionFile, err := os.Create(filepath.Join("PrepForUpload", "MercuryVersion.txt"))
	Assert(err, "Could not create MercuryVersion.txt")
	fmt.Fprint(versionFile, fileVersion)
	versionFile.Close()

	_, err = io.Copy(destination1, launcher)
	Assert(err, "Could not copy MercuryPlayerLauncher.exe to setup")
	_, err = io.Copy(destination2, launcher)
	Assert(err, "Could not copy MercuryPlayerLauncher.exe to PrepForUpload")
}

func TexturesHalf(half uint8) []string {
	files, err := os.ReadDir("staging/content/textures")
	Assert(err, "Could not read directory staging/content/textures")

	var filenames []string
	for _, file := range files {
		if !file.IsDir() {
			filenames = append(filenames, file.Name())
		}
	}

	if half == 2 {
		return filenames[len(filenames)/2:]
	}
	return append(filenames[:len(filenames)/2], "ui")
}

func main() {
	fmt.Println(c.InBold("\n  -- Mercury Setup Deployer 3: Now with more EVERYTHING! --  \n"))
	currentVersion := "none"

	// what a great coincidence that the timestamp exactly 16 characters long (or rather will be, for a very very long time)
	// also makes it way easier to order the versions in a file explorer than a random string
	newVersion := fmt.Sprintf("version-%x", time.Now().UnixNano())

	// Get version from setup directory/version.txt
	versionFile, err := os.Open(filepath.Join("setup", "version.txt"))
	if err == nil {
		fmt.Fscanf(versionFile, "%s", &currentVersion)
		versionFile.Close()
	}

	fmt.Println("Current version is", c.InBlue(currentVersion))
	fmt.Println("New version to be deployed will have a version hash of", c.InBlue(newVersion))
	fmt.Println(c.InGreen("Now commencing deployment\n"))

	// Find if there are any files in the staging directory
	stagingFiles, err := os.ReadDir("staging")
	Assert(err, "Could not read staging directory. Please create the staging directory if it doesn't exist and place your files in it, or run this script from a different directory.")
	if len(stagingFiles) == 0 {
		fmt.Println(c.InRed("Error:"), "Staging directory is empty. Please place your files in the staging directory, or run this script from a different directory.")
		os.Exit(1)
	}

	// Create directories
	os.RemoveAll("PrepForUpload")
	os.Mkdir("PrepForUpload", os.ModePerm)
	// Deferring means we likely don't need to deal with file handles
	defer os.RemoveAll("PrepForUpload")
	os.Mkdir("setup", os.ModePerm)

	// Get all files in the staging directory that end with .dll
	dllFiles := []string{}
	for _, file := range stagingFiles {
		if strings.HasSuffix(file.Name(), ".dll") {
			dllFiles = append(dllFiles, file.Name())
		}
	}

	for _, task := range tasks {
		fmt.Println()
		list = append(list, Task{name: task})
	}
	wg.Add(len(tasks))

	// I LOVE GOROUTINES!!!
	go UpdateVersion(tasks[0], newVersion)
	go CopyLauncher(tasks[1])
	go ZipFromArray(tasks[2], []string{"Microsoft.VC90.CRT", "Microsoft.VC90.MFC", "Microsoft.VC90.OPENMP"}, "", true)
	go ZipFromArray(tasks[3], []string{"MercuryPlayerBeta.exe", "MercuryStudioBeta.exe", "ReflectionMetadata.xml", "RobloxStudioRibbon.xml"}, "", false)
	go ZipFromArray(tasks[4], dllFiles, "", false)
	go ZipFromArray(tasks[5], TexturesHalf(1), "content/textures", false)
	go ZipFromArray(tasks[6], TexturesHalf(2), "content/textures", false)
	go ZipFromFolder(tasks[7], "PlatformContent/pc/textures")
	go ZipFromFolder(tasks[8], "content/sky")
	go ZipFromFolder(tasks[9], "content/fonts")
	go ZipFromFolder(tasks[10], "content/music")
	go ZipFromFolder(tasks[11], "content/sounds")
	go ZipFromFolder(tasks[12], "content/particles")
	go ZipFromFolder(tasks[13], "BuiltInPlugins")
	go ZipFromFolder(tasks[14], "imageformats")
	go ZipFromFolder(tasks[15], "shaders")

	// Wait for goroutines to finish
	wg.Wait()

	finalPath := path.Join("setup", newVersion)
	fmt.Println(c.InYellow("Copying contents of "+c.InUnderline("PrepForUpload")) + c.InYellow(" to "+c.InUnderline(finalPath)))

	// Copy all files in PrepForUpload to setup/newVersion
	// the slow way, because copying the entire directory at once causes access denied errors
	files, err := os.ReadDir("PrepForUpload")
	Assert(err, "Could not read temporary PrepForUpload directory")

	for _, file := range files {
		filename := file.Name()

		file, err := os.Open(filepath.Join("PrepForUpload", filename))
		Assert(err, "Could not read file "+filename)
		defer file.Close()

		// Create directories
		err = os.MkdirAll(filepath.Join(finalPath, filepath.Dir(filename)), os.ModePerm)
		Assert(err, "Could not create directory "+filepath.Join(finalPath, filepath.Dir(filename)))

		destination, err := os.Create(filepath.Join(finalPath, filename))
		Assert(err, "Could not create file "+filepath.Join(finalPath, filename))

		_, err = io.Copy(destination, file)
		Assert(err, "Could not copy file "+filename)
	}

	fmt.Println(c.InGreen(" ~~~~  Deployment complete!!  ~~~~"))
	fmt.Println("Took", c.InBold(fmt.Sprint(time.Since(timeStart))), "to deploy")
}
