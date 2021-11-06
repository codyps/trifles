package main

import (
	"net"
	"fmt"
)

func main() {
	addr, err := net.ResolveUDPAddr("udp6", "")
	if err != nil {
		fmt.Println("err! ", err)
	} else {
		fmt.Println("addr: ", addr)
	}
}
