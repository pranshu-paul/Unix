package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
)

type Request struct {
	InstanceIDs []string `json:"instanceId"`
}

func handler(ctx context.Context, req Request) {
	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		fmt.Printf("Error loading AWS config: %v\n", err)
		return
	}

	client := ec2.NewFromConfig(cfg)

	// Replace InstanceIDs with the actual IDs of the instances you want to start
	instanceIDs := req.InstanceIDs

	_, err = client.StartInstances(ctx, &ec2.StartInstancesInput{InstanceIds: instanceIDs})

	if err != nil {
		fmt.Printf("Error starting instances: %v\n", err)
		return
	}

	fmt.Printf("Instances %v have been started.\n", instanceIDs)
}

func main() {
	lambda.Start(handler)
}
