package main

import "C"

import (
	"github.com/hiro-o918/pyo3-bazel/golib"
)

//export echo
func echo(message *C.char) {
	golib.Echo("Go:> " + C.GoString(message))
}

func main() {}
