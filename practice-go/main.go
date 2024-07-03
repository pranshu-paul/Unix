package main

// Descriptions: Sends EC2 instance public IPs to slack channels
// Date: 26-Jun-2024
// State: Working

import (
	"context"
	"fmt"
	"sync"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
	"github.com/slack-go/slack"
)

type data struct {
	InstanceId []string `json:"instanceId"`
	ChannelIDs []string `json:"channelIds"`
	Token      string   `json:"token"`
}

func handler(ctx context.Context, val *data) (string, error) {
	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		panic(err)
	}

	ec2_client := ec2.NewFromConfig(cfg)
	input := &ec2.DescribeInstancesInput{InstanceIds: val.InstanceId}

	result, _ := ec2_client.DescribeInstances(ctx, input)

	var ip []string
	for _, reservation := range result.Reservations {
		for _, instance := range reservation.Instances {
			ip = append(ip, *instance.PublicIpAddress)
		}
	}

	client := slack.New(val.Token)

	message := fmt.Sprintf("osTicket instance public IP: %s", ip)

	var wg sync.WaitGroup
	wg.Add(len(val.ChannelIDs))

	for _, channelID := range val.ChannelIDs {
		go func(channelID string) {
			defer wg.Done()

			_, _, err := client.PostMessage(
				channelID,
				slack.MsgOptionText(message, false),
			)

			if err != nil {
				fmt.Printf("Failed to sent on channel %s: %v", channelID, err)
				return
			}

			fmt.Printf("Sent to channel %s\n", channelID)
		}(channelID)
	}

	wg.Wait()
	return fmt.Sprintf("Sent public ip: %s to the channels: %s", ip, val.ChannelIDs), nil
}

func main() {
	lambda.Start(handler)
}
