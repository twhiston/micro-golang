package main

import (
	"bytes"
	"log"
	"os"
	"strings"
	"testing"
)

func TestGreet(t *testing.T) {

	output := captureOutput(func() {
		Greet("testbot")
	})

	if strings.Compare(strings.TrimRight(output, "\n"), "hello testbot") != 0 {
		t.Error("did not return expected string", "returned", output)
	}

}

func captureOutput(f func()) string {
	var buf bytes.Buffer
	log.SetOutput(&buf)
	log.SetFlags(0)
	f()
	log.SetOutput(os.Stderr)
	return buf.String()
}
