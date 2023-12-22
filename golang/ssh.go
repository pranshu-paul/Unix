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

func runSSHCommand(host, user, privateKeyPath, command string, port string) {
	privateKey, err := os.ReadFile(privateKeyPath)
	checkError(err)

	signer, err := ssh.ParsePrivateKey(privateKey)
	checkError(err)

	authMethod := []ssh.AuthMethod{ssh.PublicKeys(signer)}
	hostKeyCallback := ssh.InsecureIgnoreHostKey()

	config := &ssh.ClientConfig{User: user, Auth: authMethod, HostKeyCallback: hostKeyCallback}

	client, err := ssh.Dial("tcp", host+":"+port, config)
	checkError(err)
	defer client.Close()

	session, err := client.NewSession()
	checkError(err)
	defer session.Close()

	output, err := session.CombinedOutput(command)
	checkError(err)

	fmt.Printf("Output from %s:\n%s\n", host, output)
}

func main() {
	hosts := []string{"168.138.114.133"}
	users := []string{"paul"}
	port := "2169"
	privateKeyPaths := []string{"C:\\Users\\Pranshu\\.ssh\\id_rsa"}

	command := "echo Hello, SSH! From $HOSTNAME"

	for i := 0; i < len(hosts); i++ {
		runSSHCommand(hosts[i], users[i], privateKeyPaths[i], command, port)
	}
}
