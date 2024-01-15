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
)

func Error(txt string) {
	fmt.Println(c.InRed("Error: ") + txt)
	os.Exit(1)
}

func Log(txt string) {
	spaces := 70 - len(txt)
	fmt.Print(txt + strings.Repeat(" ", spaces))
}

type Task struct {
	name      string
	timeStart int
	timeEnd   int
}

type TaskList struct {
	tasks []Task
}

func (t *TaskList) Update() {
	// clear last x lines, where x is the number of tasks
	toPrint := "\033[" + fmt.Sprint(len(t.tasks)) + "A"

	// print all tasks, with [ Done! ] at the end if they are completed

	for _, task := range t.tasks {
		spaces := 50 - len(task.name)
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
}

var list = TaskList{tasks: []Task{}}

func RandomString() string {
	// generate a hexadecimal string of a given size
	const hex = "0123456789abcdef"
	buf := make([]byte, 16)
	for i := range buf {
		buf[i] = hex[rand.Intn(len(hex))]
	}
	return string(buf)
}

func WriteFile(writer *zip.Writer, pathName string, entryName string) {
	// read file
	file, err := os.Open(pathName)
	if err != nil {
		Error("Could not read file " + pathName)
	}
	defer file.Close()

	// create zip entry
	entry, err := writer.Create(entryName)
	if err != nil {
		Error("Could not create zip entry " + entryName)
	}

	// copy file to zip entry
	_, err = io.Copy(entry, file)
	if err != nil {
		fmt.Println(err)
		Error("Could not copy file " + pathName + " to zip entry " + entryName)
	}
}

func WriteFolder(writer *zip.Writer, pathName string, entryName string) {
	// read directory
	files, err := os.ReadDir(pathName)
	if err != nil {
		Error("Could not read directory " + pathName)
	}

	// write files to zip entry
	for _, file := range files {
		if file.IsDir() {
			WriteFolder(writer, path.Join(pathName, file.Name()), entryName+"/"+file.Name())
		} else {
			WriteFile(writer, path.Join(pathName, file.Name()), entryName+"/"+file.Name())
		}
	}
}

func zipFromArray(wg *sync.WaitGroup, destination string, sources []string, baseDirectory string, isFolder bool) {
	defer wg.Done()

	var entryName string

	zipFile, err := os.Create(destination)
	if err != nil {
		Error("Could not create zip file " + destination)
	}

	archive := zip.NewWriter(zipFile)

	for _, file := range sources {
		if len(baseDirectory) > 0 {
			entryName = strings.TrimPrefix(file, baseDirectory)
		} else {
			entryParts := strings.Split(file, "/")
			entryName = entryParts[len(entryParts)-1]
		}

		pathName := path.Join("staging", baseDirectory+file)
		if entryName == "ui" {
			WriteFolder(archive, pathName, "ui")
		} else if isFolder {
			WriteFolder(archive, pathName, baseDirectory+file)
		} else {
			WriteFile(archive, pathName, baseDirectory+file)
		}
	}

	list.CompleteTask(destination)
	archive.Close()
}

func main() {
	cwd, err := os.Getwd()
	if err != nil {
		Error("Could not get current working directory")
	}
	setupDirectory := filepath.Join(cwd, "setup")
	versionHash := RandomString()

	fmt.Println(c.InBold("\n  -- Mercury Setup Deployer --  \n"))
	var currentVersion string
	newVersion := "version-" + versionHash

	// get version from setup directory/version.txt
	versionFile, err := os.Open(filepath.Join(setupDirectory, "version.txt"))
	if err != nil {
		currentVersion = "none"
	}
	fmt.Fscanf(versionFile, "%s", &currentVersion)
	versionFile.Close()

	fmt.Println("Current version is", c.InBlue(currentVersion))
	fmt.Println("New version to be deployed will have a version hash of", c.InBlue(newVersion))
	fmt.Println(c.InGreen("Now commencing deployment\n"))

	// create staging directory
	os.Mkdir(filepath.Join(cwd, "staging"), 0777)
	os.Mkdir(filepath.Join(cwd, "PrepForUpload"), 0777)

	// find if there are any files in the staging directory
	stagingFiles, err := os.ReadDir(filepath.Join(cwd, "staging"))
	if err != nil {
		Error("Could not read staging directory")
	}
	if len(stagingFiles) == 0 {
		Error("Staging directory is empty")
	}

	// create a waitgroup to wait for all goroutines to finish
	var wg sync.WaitGroup

	fmt.Println(c.InPurple("Preparing " + c.InUnderline("Mercury.zip")))

	// get all files in the staging directory that end with .dll
	dllFiles := []string{}
	for _, file := range stagingFiles {
		if strings.HasSuffix(file.Name(), ".dll") {
			dllFiles = append(dllFiles, file.Name())
		}
	}

	tasks := []string{
		"PrepForUpload/redist.zip",
		"PrepForUpload/Mercury.zip",
		"PrepForUpload/Libraries.zip",
	}

	list.AddTasks(tasks)
	wg.Add(len(tasks))

	go zipFromArray(&wg, tasks[0], []string{"Microsoft.VC90.CRT", "Microsoft.VC90.MFC", "Microsoft.VC90.OPENMP"}, "", true)
	go zipFromArray(&wg, tasks[1], []string{"MercuryPlayerBeta.exe", "MercuryStudioBeta.exe", "ReflectionMetadata.xml", "RobloxStudioRibbon.xml"}, "", false)
	go zipFromArray(&wg, tasks[2], dllFiles, "", false)

	// wait for gorooutines to finish
	wg.Wait()

	fmt.Println(" ~~~~  Deployment complete!!  ~~~~")
}
