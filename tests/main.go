package main

import (
	"log"
)

func main() {
	Greet("anonymous weirdo")
}

//Greet will greet you for a test
func Greet(name string) {
	log.Println("hello", name)
}
