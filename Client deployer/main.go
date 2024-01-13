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

func Done() {
	fmt.Println(c.InBlackOverGreen(" Done! "))
}

func RandomString() string {
	// generate a hexadecimal string of a given size
	const hex = "0123456789abcdef"
	buf := make([]byte, 16)
	for i := range buf {
		buf[i] = hex[rand.Intn(len(hex))]
	}
	return string(buf)
}

func WriteToZip(writer *zip.Writer, pathName string, entryName string, isFolder bool) {
	if isFolder {
		// read directory
		files, err := os.ReadDir(pathName)
		if err != nil {
			Error("Could not read directory " + pathName)
		}

		// write files to zip entry
		for _, file := range files {
			WriteToZip(writer, path.Join(pathName, file.Name()), entryName+"/"+file.Name(), file.IsDir())
		}
	} else {
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
			Error("Could not copy file " + pathName + " to zip entry " + entryName)
		}
	}
}

func zipFromArray(sources []string, destination string, baseDirectory string, isFolder bool) {
	Log(c.InBlue("Creating " + c.InUnderline(destination)))
	var entryName string

	zipFile, err := os.Create(destination)
	if err != nil {
		Error("Could not create zip file " + destination)
	}
	defer zipFile.Close()

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
			WriteToZip(archive, pathName, "ui", true)
		} else {
			WriteToZip(archive, pathName, baseDirectory+file, isFolder)
		}
	}
	archive.Close()
	Done()
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

	fmt.Println(c.InPurple("Preparing " + c.InUnderline("Mercury.zip")))

	zipFromArray([]string{
		"MercuryPlayerBeta.exe",
		"MercuryStudioBeta.exe",
		"ReflectionMetadata.xml",
		"RobloxStudioRibbon.xml",
	}, "PrepForUpload/Mercury.zip", "", false)

	// get all files in the staging directory that end with .dll
	dllFiles := []string{}
	for _, file := range stagingFiles {
		if strings.HasSuffix(file.Name(), ".dll") {
			dllFiles = append(dllFiles, file.Name())
		}
	}
	zipFromArray(dllFiles, "PrepForUpload/Libraries.zip", "", false)

	fmt.Println(c.InBlue("Creating " + c.InUnderline("redist.zip")))

	zipFromArray([]string{
		"Microsoft.VC90.CRT",
		"Microsoft.VC90.MFC",
		"Microsoft.VC90.OPENMP",
	}, "PrepForUpload/redist.zip", "", true)

	fmt.Println(" ~~~~  Deployment complete!!  ~~~~")
}
