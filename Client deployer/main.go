package main

import (
	"archive/zip"
	"fmt"
	"io"
	"math/rand"
	"os"
	"path"
	"path/filepath"
	"strings"
	"sync"
	"time"

	c "github.com/TwiN/go-color"
	fileversion "github.com/bi-zone/go-fileversion"
)

func Error(txt string) {
	fmt.Println(c.InRed("Error: ") + txt)
	os.Exit(1)
}

func Assert(err error, txt string) {
	if err != nil {
		fmt.Println(err)
		Error(txt)
	}
}

// Create a waitgroup to wait for all goroutines to finish
var wg = sync.WaitGroup{}

type Task struct {
	name      string
	timeStart int
	timeEnd   int
}

type TaskList struct {
	tasks []Task
}

func (t *TaskList) Update() {
	// Clear last x lines, where x is the number of tasks
	toPrint := fmt.Sprintf("\033[%dA", len(t.tasks))

	// Print all tasks, with [ Done! ] at the end if they are completed

	for _, task := range t.tasks {
		spaces := 30 - len(task.name)
		toPrint += c.InBlue("Creating " + c.InUnderline(task.name) + strings.Repeat(" ", spaces))
		if task.timeEnd > 0 {
			toPrint += c.InBlackOverGreen(" Done! (" + fmt.Sprint(task.timeEnd-task.timeStart) + "ms) ")
		}

		toPrint += "\n"
	}

	fmt.Print(toPrint)
}

func (t *TaskList) AddTask(task string) {
	fmt.Println()
	t.tasks = append(t.tasks, Task{name: task, timeStart: int(time.Now().UnixNano() / int64(time.Millisecond))})
	t.Update()
}

func (t *TaskList) AddTasks(tasks []string) {
	fmt.Print(strings.Repeat("\n", len(tasks)))
	for _, task := range tasks {
		t.tasks = append(t.tasks, Task{name: task, timeStart: int(time.Now().UnixNano() / int64(time.Millisecond))})
	}
	t.Update()
}

func (t *TaskList) CompleteTask(completedTask string) {
	for i, task := range t.tasks {
		if task.name == completedTask {
			t.tasks[i].timeEnd = int(time.Now().UnixNano() / int64(time.Millisecond))
		}
	}
	t.Update()
	wg.Done()
}

var list = TaskList{tasks: []Task{}}

func RandomString() string {
	// Generate a hexadecimal string of a given size
	const hex = "0123456789abcdef"
	buf := make([]byte, 16)
	for i := range buf {
		buf[i] = hex[rand.Intn(len(hex))]
	}
	return string(buf)
}

func WriteFile(writer *zip.Writer, pathName string, entryName string) {
	// Read file
	file, err := os.Open(pathName)
	Assert(err, "Could not read file "+pathName)
	defer file.Close()

	// Create zip entry
	entry, err := writer.Create(entryName)
	Assert(err, "Could not create zip entry "+entryName)

	// Copy file to zip entry
	_, err = io.Copy(entry, file)
	Assert(err, "Could not copy file "+pathName+" to zip entry "+entryName)
}

func WriteFolder(writer *zip.Writer, pathName string, entryName string) {
	// Read directory
	files, err := os.ReadDir(pathName)
	Assert(err, "Could not read directory "+pathName)

	// Write files to zip entry
	for _, file := range files {
		if file.IsDir() {
			WriteFolder(writer, path.Join(pathName, file.Name()), entryName+"/"+file.Name())
		} else {
			WriteFile(writer, path.Join(pathName, file.Name()), entryName+"/"+file.Name())
		}
	}
}

func ZipFromArray(destination string, sources []string, baseDirectory string, isFolder bool) {
	defer list.CompleteTask(destination)
	destination = filepath.Join("PrepForUpload", destination)

	zipFile, err := os.Create(destination)
	Assert(err, "Could not create zip file "+destination)

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
			WriteFile(archive, pathName, baseDirectory+file)
		}
	}
}

func ZipFromFolder(destination string, source string) {
	defer list.CompleteTask(destination)
	destination = filepath.Join("PrepForUpload", destination)

	zipFile, err := os.Create(destination)
	Assert(err, "Could not create zip file "+destination)

	archive := zip.NewWriter(zipFile)
	defer archive.Close()

	WriteFolder(archive, source, "")
}

func TexturesHalf(first bool) []string {
	// Read staging/content/textures
	files, err := os.ReadDir("staging/content/textures")
	Assert(err, "Could not read directory staging/content/textures")

	var filenames []string
	for _, file := range files {
		if !file.IsDir() {
			filenames = append(filenames, file.Name())
		}
	}

	if first {
		filenames = filenames[:len(filenames)/2]
		filenames = append(filenames, "ui")
	} else {
		filenames = filenames[len(filenames)/2:]
	}

	return filenames
}

func CopyTerrainPlugins(cwd string) {
	os.MkdirAll(filepath.Join(cwd, "staging", "BuiltInPlugins", "terrain"), 0777)

	// Copy terrain plugins/processed to staging/BuiltInPlugins/terrain
	plugins, err := os.ReadDir(filepath.Join(cwd, "terrain plugins", "processed"))
	Assert(err, "Could not read directory terrain plugins/processed")
	for _, plugin := range plugins {
		// Copy plugin to staging/BuiltInPlugins/terrain
		pluginFile, err := os.Open(filepath.Join(cwd, "terrain plugins", "processed", plugin.Name()))
		Assert(err, "Could not read file terrain plugins/processed/"+plugin.Name())
		defer pluginFile.Close()

		pluginDestination, err := os.Create(filepath.Join(cwd, "staging", "BuiltInPlugins", "terrain", plugin.Name()))
		Assert(err, "Could not create file staging/BuiltInPlugins/terrain/"+plugin.Name())
		defer pluginDestination.Close()

		_, err = io.Copy(pluginDestination, pluginFile)
		Assert(err, "Could not copy terrain plugins/processed/"+plugin.Name())
	}

	list.CompleteTask("terrain plugins")
}

func RecursiveRead(path string) []string {
	files, err := os.ReadDir(path)
	Assert(err, "Could not read directory "+path)

	var filenames []string
	for _, file := range files {
		if file.IsDir() {
			filenames = append(filenames, RecursiveRead(filepath.Join(path, file.Name()))...)
		} else {
			filenames = append(filenames, filepath.Join(path, file.Name()))
		}
	}
	return filenames
}

func main() {
	cwd, err := os.Getwd()
	Assert(err, "Could not get current working directory")
	setupDirectory := filepath.Join(cwd, "setup")
	versionHash := RandomString()

	fmt.Println(c.InBold("\n  -- Mercury Setup Deployer --  \n"))
	var currentVersion string
	newVersion := "version-" + versionHash

	// Get version from setup directory/version.txt
	versionFile, err := os.Open(filepath.Join(setupDirectory, "version.txt"))
	if err != nil {
		currentVersion = "none"
	}
	fmt.Fscanf(versionFile, "%s", &currentVersion)
	versionFile.Close()

	fmt.Println("Current version is", c.InBlue(currentVersion))
	fmt.Println("New version to be deployed will have a version hash of", c.InBlue(newVersion))
	fmt.Println(c.InGreen("Now commencing deployment\n"))

	// remove PreForUpload directory
	os.RemoveAll("PrepForUpload")

	// Create staging directory
	os.Mkdir("staging", 0777)
	os.Mkdir("PrepForUpload", 0777)

	// Find if there are any files in the staging directory
	stagingFiles, err := os.ReadDir(filepath.Join(cwd, "staging"))
	Assert(err, "Could not read staging directory")
	if len(stagingFiles) == 0 {
		Error("Staging directory is empty")
	}

	// Get all files in the staging directory that end with .dll
	dllFiles := []string{}
	for _, file := range stagingFiles {
		if strings.HasSuffix(file.Name(), ".dll") {
			dllFiles = append(dllFiles, file.Name())
		}
	}

	tasks := []string{
		"version.txt",
		"terrain plugins",
		"MercuryPlayerLauncher.exe",
		"redist.zip",
		"Mercury.zip",
		"Libraries.zip",
		"content-textures.zip",
		"content-textures2.zip",
		"content-sky.zip",
		"content-fonts.zip",
		"content-music.zip",
		"content-sounds.zip",
		"content-particles.zip",
		"BuiltInPlugins.zip",
		"imageformats.zip",
		"shaders.zip",
	}

	list.AddTasks(tasks)
	wg.Add(len(tasks))

	go (func() {
		// Update version.txt with the new version
		versionFile, err := os.Create(filepath.Join(setupDirectory, "version.txt"))
		Assert(err, "Could not create version.txt")
		defer versionFile.Close()
		fmt.Fprint(versionFile, newVersion)
		list.CompleteTask(tasks[0])
	})()

	go CopyTerrainPlugins(cwd)

	go (func() {
		// Copy MercuryPlayerLauncher.exe to staging
		launcher, err := os.Open(filepath.Join(setupDirectory, "MercuryPlayerLauncher.exe"))
		Assert(err, "Could not read MercuryPlayerLauncher.exe")
		defer launcher.Close()

		destination1, err := os.Create(filepath.Join(cwd, "staging", "MercuryPlayerLauncher.exe"))
		destination2, err := os.Create(filepath.Join(cwd, "PrepForUpload", "MercuryPlayerLauncher.exe"))
		Assert(err, "Could not create MercuryPlayerLauncher.exe")
		defer destination1.Close()
		defer destination2.Close()

		fv, err := fileversion.New("setup/MercuryPlayerLauncher.exe")
		Assert(err, "Could not get file version of MercuryPlayerLauncher.exe")
		fileVersion := fv.FileVersion()

		// Write version to MercuryVersion.txt
		fmt.Fprint(versionFile, fileVersion)

		_, err = io.Copy(destination1, launcher)
		_, err = io.Copy(destination2, launcher)
		Assert(err, "Could not copy MercuryPlayerLauncher.exe")

		list.CompleteTask(tasks[2])
	})()

	go ZipFromArray(tasks[3], []string{"Microsoft.VC90.CRT", "Microsoft.VC90.MFC", "Microsoft.VC90.OPENMP"}, "", true)
	go ZipFromArray(tasks[4], []string{"MercuryPlayerBeta.exe", "MercuryStudioBeta.exe", "ReflectionMetadata.xml", "RobloxStudioRibbon.xml"}, "", false)
	go ZipFromArray(tasks[5], dllFiles, "", false)
	go ZipFromArray(tasks[6], TexturesHalf(true), "content/textures", false)
	go ZipFromArray(tasks[7], TexturesHalf(false), "content/textures", false)
	go ZipFromFolder(tasks[8], "staging/content/sky")
	go ZipFromFolder(tasks[9], "staging/content/fonts")
	go ZipFromFolder(tasks[10], "staging/content/music")
	go ZipFromFolder(tasks[11], "staging/content/sounds")
	go ZipFromFolder(tasks[12], "staging/content/particles")
	go ZipFromFolder(tasks[13], "staging/BuiltInPlugins")
	go ZipFromFolder(tasks[14], "staging/imageformats")
	go ZipFromFolder(tasks[15], "staging/shaders")

	// Wait for goroutines to finish
	wg.Wait()

	finalPath := path.Join("setup", newVersion)
	fmt.Println(c.InYellow("Copying contents of "+c.InUnderline("PrepForUpload")) + c.InYellow(" to "+c.InUnderline(finalPath)))

	// Copy all files in PrepForUpload to setup/newVersion
	// the slow way, because copying the entire directory at once
	// causes access denied errors
	for _, filename := range RecursiveRead("PrepForUpload") {
		file, err := os.Open(filename)
		Assert(err, "Could not read file "+filename)
		defer file.Close()

		// create directories
		err = os.MkdirAll(filepath.Join(finalPath, filepath.Dir(filename)), 0777)
		Assert(err, "Could not create directory "+filepath.Join(finalPath, filepath.Dir(filename)))

		destination, err := os.Create(filepath.Join(finalPath, filename))
		Assert(err, "Could not create file "+filepath.Join(finalPath, filename))

		_, err = io.Copy(destination, file)
		Assert(err, "Could not copy file "+filename)
	}

	fmt.Println(c.InGreen(" ~~~~  Deployment complete!!  ~~~~"))
}
