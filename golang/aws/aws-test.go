package main

import (
	"context"

	"github.com/aws/aws-sdk-go-v2/config"
)

func checkError(err error) {
	if err != nil {
		panic(err)
	}
}

func main() {
	cfg, err := config.LoadDefaultConfig(context.Background(), config.WithSharedConfigProfile("pranshu"))
	checkError(err)

}
