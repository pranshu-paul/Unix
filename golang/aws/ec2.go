package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
)

func main() {
	cfg, _ := config.LoadDefaultConfig(context.TODO())

	client := ec2.NewFromConfig(cfg)

	instanceIDs := []string{"i-0ffc729759a32ddf3", "i-02f2e41a567c05ba0"}

	client.StartInstances(context.TODO(), &ec2.StartInstancesInput{InstanceIds: instanceIDs})

	fmt.Printf("Instance %s has been started.\n", instanceIDs)
}
