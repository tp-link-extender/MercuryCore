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

// what a great coincidence that this is exactly 16 characters long
// also makes it way easier to order the versions in a file explorer than a random string
var versionHash = fmt.Sprintf("%x", time.Now().UnixNano())

func Error(txt string) {
	fmt.Println(c.InRed("Error: ") + txt)
	os.Exit(1)
}

func Assert(err error, txt string) {
	// so that I don't have to write this every time
	if err != nil {
		fmt.Println(err)
		Error(txt)
	}
}

// Create a waitgroup to wait for all goroutines to finish
var wg sync.WaitGroup

type Task struct {
	name      string
	timeStart int
	timeEnd   int
}

type TaskList struct {
	tasks []Task
}

func (t *TaskList) Update() {
	// Clear last printed tasks
	toPrint := fmt.Sprintf("\033[%dA", len(t.tasks))

	// Print all tasks, with "Done! (0ms)" at the end if they are completed
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
			fmt.Println("Writing", pathName, "to", file)
			WriteFile(archive, pathName, file)
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

	WriteFolder(archive, filepath.Join("staging", source), "")
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
		return append(filenames[:len(filenames)/2], "ui")
	}
	return filenames[len(filenames)/2:]
}

func main() {
	fmt.Println(c.InBold("\n  -- Mercury Setup Deployer 3: Now with more EVERYTHING! --  \n"))
	var currentVersion string
	newVersion := "version-" + versionHash

	// Get version from setup directory/version.txt
	versionFile, err := os.Open(filepath.Join("setup", "version.txt"))
	if err != nil {
		currentVersion = "none"
	}
	fmt.Fscanf(versionFile, "%s", &currentVersion)
	versionFile.Close()

	fmt.Println("Current version is", c.InBlue(currentVersion))
	fmt.Println("New version to be deployed will have a version hash of", c.InBlue(newVersion))
	fmt.Println(c.InGreen("Now commencing deployment\n"))

	// Find if there are any files in the staging directory
	stagingFiles, err := os.ReadDir("staging")
	Assert(err, "Could not read staging directory")
	if len(stagingFiles) == 0 {
		Error("Staging directory is empty. Please place your files in the staging directory, or run this script from a different directory.")
	}

	// remove PreForUpload directory
	os.RemoveAll("PrepForUpload")

	// Create staging directory
	os.Mkdir("staging", 0777)
	os.Mkdir("PrepForUpload", 0777)
	os.Mkdir("setup", 0777)

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

	list.AddTasks(tasks)
	wg.Add(len(tasks))

	go (func() {
		// Update version.txt with the new version
		versionFile, err := os.Create(filepath.Join("setup", "version.txt"))
		Assert(err, "Could not create version.txt")
		defer versionFile.Close()
		fmt.Fprint(versionFile, newVersion)
		list.CompleteTask(tasks[0])
	})()

	go (func() {
		os.MkdirAll(filepath.Join("staging", "BuiltInPlugins", "terrain"), 0777)

		// Copy terrain plugins/processed to staging/BuiltInPlugins/terrain (pretty mercury specific but ye)
		plugins, err := os.ReadDir(filepath.Join("terrain plugins", "processed"))
		Assert(err, "Could not read directory terrain plugins/processed")
		for _, plugin := range plugins {
			// Copy plugin to staging/BuiltInPlugins/terrain
			pluginFile, err := os.Open(filepath.Join("terrain plugins", "processed", plugin.Name()))
			Assert(err, "Could not read file terrain plugins/processed/"+plugin.Name())
			defer pluginFile.Close()

			pluginDestination, err := os.Create(filepath.Join("staging", "BuiltInPlugins", "terrain", plugin.Name()))
			Assert(err, "Could not create file staging/BuiltInPlugins/terrain/"+plugin.Name())
			defer pluginDestination.Close()

			_, err = io.Copy(pluginDestination, pluginFile)
			Assert(err, "Could not copy terrain plugins/processed/"+plugin.Name())
		}

		list.CompleteTask("terrain plugins")
	})()

	go (func() {
		// Copy MercuryPlayerLauncher.exe to setup
		launcher, err := os.Open(filepath.Join("staging", tasks[2]))
		Assert(err, "Could not read MercuryPlayerLauncher.exe")
		defer launcher.Close()

		destination1, err := os.Create(filepath.Join("setup", tasks[2]))
		Assert(err, "Could not create MercuryPlayerLauncher.exe (1)")
		defer destination1.Close()
		destination2, err := os.Create(filepath.Join("PrepForUpload", tasks[2]))
		Assert(err, "Could not create MercuryPlayerLauncher.exe (2)")
		defer destination2.Close()

		fv, err := fileversion.New(filepath.Join("staging", "MercuryPlayerLauncher.exe"))
		Assert(err, "Could not get file version of MercuryPlayerLauncher.exe")
		fileVersion := fv.FileVersion()

		// Write version to MercuryVersion.txt
		versionFile, err := os.Create(filepath.Join("PrepForUpload", "MercuryVersion.txt"))
		Assert(err, "Could not create MercuryVersion.txt")
		defer versionFile.Close()
		fmt.Fprint(versionFile, fileVersion)

		_, err = io.Copy(destination1, launcher)
		Assert(err, "Could not copy MercuryPlayerLauncher.exe (1)")
		_, err = io.Copy(destination2, launcher)
		Assert(err, "Could not copy MercuryPlayerLauncher.exe (2)")

		list.CompleteTask(tasks[2])
	})()

	// I LOVE GOROUTINES!!!
	go ZipFromArray(tasks[3], []string{"Microsoft.VC90.CRT", "Microsoft.VC90.MFC", "Microsoft.VC90.OPENMP"}, "", true)
	go ZipFromArray(tasks[4], []string{"MercuryPlayerBeta.exe", "MercuryStudioBeta.exe", "ReflectionMetadata.xml", "RobloxStudioRibbon.xml"}, "", false)
	go ZipFromArray(tasks[5], dllFiles, "", false)
	go ZipFromArray(tasks[6], TexturesHalf(true), "content/textures", false)
	go ZipFromArray(tasks[7], TexturesHalf(false), "content/textures", false)
	go ZipFromFolder(tasks[8], "PlatformContent/pc/textures")
	go ZipFromFolder(tasks[9], "content/sky")
	go ZipFromFolder(tasks[10], "content/fonts")
	go ZipFromFolder(tasks[11], "content/music")
	go ZipFromFolder(tasks[12], "content/sounds")
	go ZipFromFolder(tasks[13], "content/particles")
	go ZipFromFolder(tasks[14], "BuiltInPlugins")
	go ZipFromFolder(tasks[15], "imageformats")
	go ZipFromFolder(tasks[16], "shaders")

	// Wait for goroutines to finish
	wg.Wait()

	finalPath := path.Join("setup", newVersion)
	fmt.Println(c.InYellow("Copying contents of "+c.InUnderline("PrepForUpload")) + c.InYellow(" to "+c.InUnderline(finalPath)))

	// Copy all files in PrepForUpload to setup/newVersion
	// the slow way, because copying the entire directory at once causes access denied errors
	files, err := os.ReadDir("PrepForUpload")
	Assert(err, "Could not read PrepForUpload directory")

	for _, file := range files {
		filename := file.Name()

		file, err := os.Open(filepath.Join("PrepForUpload", filename))
		Assert(err, "Could not read file "+filename)
		defer file.Close()

		// Create directories
		err = os.MkdirAll(filepath.Join(finalPath, filepath.Dir(filename)), 0777)
		Assert(err, "Could not create directory "+filepath.Join(finalPath, filepath.Dir(filename)))

		destination, err := os.Create(filepath.Join(finalPath, filename))
		Assert(err, "Could not create file "+filepath.Join(finalPath, filename))

		_, err = io.Copy(destination, file)
		Assert(err, "Could not copy file "+filename)
	}

	fmt.Println(c.InGreen(" ~~~~  Deployment complete!!  ~~~~"))
}
