package main

import (
	"context"
	"log"
	"strings"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
)

type data struct {
	instanceIds []string
	action      string
}

func checkError(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

func createEC2Client(ctx context.Context) *ec2.Client {
	cfg, err := config.LoadDefaultConfig(ctx)
	checkError(err)

	return ec2.NewFromConfig(cfg)
}

func startInstance(ctx context.Context, val *data, client *ec2.Client) {
	_, err := client.StartInstances(ctx, &ec2.StartInstancesInput{
		InstanceIds: val.instanceIds,
	})
	checkError(err)
}

func stopInstance(ctx context.Context, val *data, client *ec2.Client) {
	_, err := client.StopInstances(ctx, &ec2.StopInstancesInput{
		InstanceIds: val.instanceIds,
	})
	checkError(err)
}

func handler(ctx context.Context, val *data) {
	switch strings.ToLower(val.action) {
	case "start":
		startInstance(ctx, val, createEC2Client(ctx))
	case "stop":
		stopInstance(ctx, val, createEC2Client(ctx))
	}
}

func main() {
	handler(context.Background(), &data{
		instanceIds: []string{"i-05be445de2a83e423", "i-02fb9cbdd300067ec"},
		action:      "stop",
	})
}
