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

func getPublicIPs(instanceIDs []string) []string {
	cfg, err := config.LoadDefaultConfig(context.Background())
	checkError(err)

	client := ec2.NewFromConfig(cfg)

	result, err := client.DescribeInstances(context.Background(), &ec2.DescribeInstancesInput{InstanceIds: instanceIDs})
	checkError(err)

	var publicIPs []string
	for _, reservation := range result.Reservations {
		for _, instance := range reservation.Instances {
			if instance.PublicIpAddress != nil {
				publicIPs = append(publicIPs, *instance.PublicIpAddress)
			}
		}
	}

	return publicIPs
}

func main() {
	instanceIDs := []string{"i-05be445de2a83e423", "i-05be445de2a83e423"}
	publicIPs := getPublicIPs(instanceIDs)

	fmt.Printf("Public IPs: %v\n", publicIPs)
}
