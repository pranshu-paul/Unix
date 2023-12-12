package main

import (
	"fmt"
	"golang.org/x/crypto/ssh"
	"io/ioutil"
	"log"
)

func checkError(err error, format string, args ...interface{}) {
	if err != nil {
		log.Fatalf(format, args...)
	}
}

func runSSHCommand(host, user, privateKeyPath, command string) {
	privateKey, err := ioutil.ReadFile(privateKeyPath)
	checkError(err, "Failed to read private key: %s", err)

	signer, err := ssh.ParsePrivateKey(privateKey)
	checkError(err, "Failed to parse private key: %s", err)

	config := &ssh.ClientConfig{
		User: user,
		Auth: []ssh.AuthMethod{
			ssh.PublicKeys(signer),
		},
		HostKeyCallback: ssh.InsecureIgnoreHostKey(),
	}

	client, err := ssh.Dial("tcp", host+":22", config)
	checkError(err, "Failed to dial: %s", err)
	defer client.Close()

	session, err := client.NewSession()
	checkError(err, "Failed to create session: %s", err)
	defer session.Close()

	output, err := session.CombinedOutput(command)
	checkError(err, "Failed to run command: %s", err)

	fmt.Printf("Output from %s:\n%s\n", host, output)
}

func main() {
	// Replace these values with your server details
	hosts := []string{"your_server1_ip", "your_server2_ip"}
	users := []string{"your_username", "your_username"}
	privateKeyPaths := []string{"/path/to/your/private/key1", "/path/to/your/private/key2"}

	command := "echo Hello, SSH!"

	for i := 0; i < len(hosts); i++ {
		runSSHCommand(hosts[i], users[i], privateKeyPaths[i], command)
	}
}
