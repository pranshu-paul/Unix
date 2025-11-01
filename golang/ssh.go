package main

import (
	"fmt"
	"os"

	"golang.org/x/crypto/ssh"
)

func checkError(err error) {
	if err != nil {
		fmt.Println(err)
	}
}

type data struct {
	host           string
	user           string
	privateKeyPath string
	command        string
	port           string
}

func runSSHCommand(val *data) {
	privateKey, err := os.ReadFile(val.privateKeyPath)
	checkError(err)

	signer, err := ssh.ParsePrivateKey(privateKey)
	checkError(err)

	hostKeyCallback := ssh.InsecureIgnoreHostKey()

	client, err := ssh.Dial("tcp", val.host+":"+val.port, &ssh.ClientConfig{
		User:            val.user,
		Auth:            []ssh.AuthMethod{ssh.PublicKeys(signer)},
		HostKeyCallback: hostKeyCallback,
	})
	checkError(err)
	defer client.Close()

	session, err := client.NewSession()
	checkError(err)
	defer session.Close()

	output, err := session.CombinedOutput(val.command)
	checkError(err)

	fmt.Printf("Output from %s:\n%s\n", val.host, output)
}

func main() {
	runSSHCommand(&data{
		host:           "150.230.237.232",
		user:           "paul",
		privateKeyPath: "C:\\Users\\Pranshu\\.ssh\\id_rsa",
		command:        "echo Hello, SSH! From $HOSTNAME; ls",
		port:           "2169",
	})
}
