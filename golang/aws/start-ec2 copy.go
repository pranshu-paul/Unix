package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
)

func checkError(err error) {
	if err != nil {
		panic(err)
	}
}

func main() {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	checkError(err)

	client := ec2.NewFromConfig(cfg)

	instanceIDs := []string{"i-02fb9cbdd300067ec"}

	output, err := client.DescribeInstances(context.TODO(), &ec2.DescribeInstancesInput{InstanceIds: instanceIDs})

	checkError(err)

	fmt.Printf("Instances %+v have been started.\n", output)
}
