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

type details struct {
	addr        []string
	instanceIds []string
}

func (d *details) listIp() {
	cfg, err := config.LoadDefaultConfig(context.Background())
	checkError(err)

	client := ec2.NewFromConfig(cfg)
	input := &ec2.DescribeInstancesInput{InstanceIds: d.instanceIds}

	result, err := client.DescribeInstances(context.Background(), input)
	checkError(err)

	for _, reservation := range result.Reservations {
		for _, instance := range reservation.Instances {
			d.addr = append(d.addr, *instance.PublicIpAddress)
		}
	}
}

func main() {
	d := details{
		instanceIds: []string{"i-02fb9cbdd300067ec"},
	}
	d.listIp()
	fmt.Println(d.addr)
}
