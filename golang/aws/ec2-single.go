package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
)

type LambdaEvent struct {
	InstanceID string `json:"instanceId"`
}

func checkErorrs(err error) {
	if err != nil {
		fmt.Println("Error:", err)
	}
}

func LambdaHandler(ctx context.Context, event LambdaEvent) (string, error) {
	cfg, err := config.LoadDefaultConfig(ctx)
	checkErorrs(err)

	client := ec2.NewFromConfig(cfg)

	// Stop the specified EC2 instance
	_, err = client.StopInstances(ctx, &ec2.StopInstancesInput{InstanceIds: []string{event.InstanceID}})
	checkErorrs(err)

	return fmt.Sprintf("Instance %s has been stopped.", event.InstanceID), nil
}

func main() {
	// Start the Lambda function
	lambda.Start(LambdaHandler)
}
