package main

import (
	"flag"
	"fmt"

	"github.com/kumaran-bot/cbapi/version"
)

func main() {

	versionFlag := flag.Bool("version", false, "Version")
	startFlag := flag.Bool("start", false, "start")
	flag.Parse()

	if *versionFlag {
		fmt.Println("Version:", version.Version)
		return
	}

	if *startFlag {
		fmt.Println("Starting Server")
	}
}
