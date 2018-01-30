package main

import "time"

type ImageDefinition struct {
	Date           time.Time
	Version        string
	ParentTag      string
	Maintainer     string
	Glibc          bool
	Env            []string
	Scripts        bool
	DockerCommands []string
	User           string
	Entrypoint     string
	Workdir        string
	Cmd            string
}

func main() {
}
