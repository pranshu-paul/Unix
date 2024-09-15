package main

// Description: Starts and Stops EC2 instances on AWS
// Date: 15-Jun-2024
// State: Working

import (
	"context"
	"fmt"
	"strings"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
)

type data struct {
	InstanceIds []string `json:"instanceIds"`
	Action      string   `json:"action"`
}

func createEC2Client(ctx context.Context) (*ec2.Client, error) {
	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		return nil, err
	}

	return ec2.NewFromConfig(cfg), nil
}

func startInstance(ctx context.Context, val *data, client *ec2.Client) (string, error) {
	output, err := client.StartInstances(ctx, &ec2.StartInstancesInput{
		InstanceIds: val.InstanceIds,
	})

	if err != nil {
		return "", err
	}

	return fmt.Sprintf("%s %s", val.InstanceIds, output.StartingInstances[0].CurrentState.Name), nil
}

func stopInstance(ctx context.Context, val *data, client *ec2.Client) (string, error) {
	output, err := client.StopInstances(ctx, &ec2.StopInstancesInput{
		InstanceIds: val.InstanceIds,
	})

	if err != nil {
		return "", err
	}

	return fmt.Sprintf("%s %s", val.InstanceIds, output.StoppingInstances[0].CurrentState.Name), nil
}

func handler(ctx context.Context, val *data) (string, error) {

	// Function returning multiple values cannot be passed to another function directly
	client, err := createEC2Client(ctx)
	if err != nil {
		return "", err
	}

	var output string

	switch strings.ToLower(val.Action) {
	case "start":
		output, err = startInstance(ctx, val, client)
	case "stop":
		output, err = stopInstance(ctx, val, client)
	default:
		return "", fmt.Errorf("invalid action provided") // Errors must not be capitalized and no punctuations should be used at the end
	}

	return output, err
}

func main() {
	lambda.Start(handler)
}
