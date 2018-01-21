package main

import (
	"os/exec"
	"os"
	"fmt"
	"log"
	"text/template"
	"gopkg.in/yaml.v2"
	"io/ioutil"
	"flag"
	"time"
)

var toolchainFilePath string

type ToolchainDescriptor struct {
	Tools   []string
	Version string
	Date    string
	Author  string
}

func toolchainError(err error, context string) {
	if err != nil {
		log.Fatalln("	!!! Could not write toolchain file \n", err.Error(), "\n", context)
	}
}

func main() {

	tc := ToolchainDescriptor{}

	flag.StringVar(&toolchainFilePath, "f", "toolchain.yml", "path to toolchain.yml file")
	flag.Parse()

	tc.Date = time.Now().Format(time.ANSIC)

	file, err := ioutil.ReadFile(toolchainFilePath)
	toolchainError(err, "read input file")

	err = yaml.Unmarshal(file, &tc)
	toolchainError(err, "unmarshall")

	installed := make([]string, 0)

	defer func() {

		tc.Tools = installed

		t := template.New("toolchain-builder")
		t, err := t.ParseGlob("toolchain.tmpl")

		f, err := os.Create("/go/toolchain.txt")
		toolchainError(err, "make toolchain.txt file")

		defer func(r *os.File) {
			err = r.Close()
			toolchainError(err, "file close")
		}(f)

		err = t.ExecuteTemplate(f, "toolchain.tmpl", &tc)
		toolchainError(err, "template render")

	}()

	for _, v := range tc.Tools {
		err := exec.Command("go", "get", "-u", "-v", v).Run()
		if err != nil {
			fmt.Println("	Failed to install:", v, "\n", err.Error())
			continue
		}
		fmt.Println("	Installed:", v)
		installed = append(installed, v)
	}

	//Get path or exit
	gobin := os.Getenv("GOBIN")
	if gobin == "" {
		fmt.Println("	GOBIN variable is blank, leaving tools in install location")
		return
	}

}
