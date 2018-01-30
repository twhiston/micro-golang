package main

import (
	"flag"
	"fmt"
	"gopkg.in/yaml.v2"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"text/template"
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
	gobin := os.Getenv("TOOLCHAIN_BIN")
	if gobin == "" {
		fmt.Println("	TOOLCHAIN_BIN variable is blank, leaving tools in GOBIN")
		return
	}

}
