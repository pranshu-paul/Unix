package main

// Description: Updates A record in route 53
// Date: 18-Jun-2024
// State: Working

import (
	"context"
	"fmt"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
	"github.com/aws/aws-sdk-go-v2/service/route53"
	"github.com/aws/aws-sdk-go-v2/service/route53/types"
)

// TODO: Change the data type of InstanceId to slices of []byte
// TODO: Try using pointers members
type data struct {
	Name       string   `json:"name"`
	Ttl        int64    `json:"ttl"`
	InstanceId []string `json:"instanceId"`
	ZoneId     string   `json:"zoneId"`
	Action     string   `json:"action"`
}

func handler(ctx context.Context, val *data) (string, error) {

	// Load the default config and return it as type aws.Config
	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		return fmt.Sprintln("Could not load the configuration."), err
	}

	// Pass the struct as an argument and return a pointer to an ec2 client
	ec2_client := ec2.NewFromConfig(cfg)
	input := &ec2.DescribeInstancesInput{InstanceIds: val.InstanceId}

	// Call the method associated with the ec2 client and pass the instance id
	// TODO: Change the context.Background to ctx
	result, _ := ec2_client.DescribeInstances(context.Background(), input)

	// Declare a slice outside the loop body
	var ip []string
	for _, reservation := range result.Reservations {
		for _, instance := range reservation.Instances {
			// Append the value in slice ip
			ip = append(ip, *instance.PublicIpAddress)
		}
	}

	client := route53.NewFromConfig(cfg)

	output, err := client.ChangeResourceRecordSets(ctx, &route53.ChangeResourceRecordSetsInput{
		HostedZoneId: &val.ZoneId,
		ChangeBatch: &types.ChangeBatch{
			Changes: []types.Change{{
				Action: types.ChangeAction(val.Action),
				ResourceRecordSet: &types.ResourceRecordSet{
					Name: &val.Name,
					Type: types.RRTypeA,
					TTL:  &val.Ttl,
					ResourceRecords: []types.ResourceRecord{
						{Value: &ip[0]},
					},
				},
			}},
		},
	})

	if err != nil {
		return fmt.Sprintln("Could not update the record."), err
	}

	return fmt.Sprintf("DNS Name: %s, Instance ID: %s, Public IP: %s, Action: %s, Record Type: %s, Status: %s", val.Name, val.InstanceId, ip[0], val.Action, types.RRTypeA, output.ChangeInfo.Status.Values()), nil
}

func main() {

	lambda.Start(handler)

}
