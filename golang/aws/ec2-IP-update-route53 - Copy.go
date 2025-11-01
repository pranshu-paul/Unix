package main

import (
	"context"
	"fmt"
	"strings"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/route53"
)

func checkError(err error) {
	if err != nil {
		panic(err)
	}
}

type Request struct {
	ZoneId      string   `json:"zoneId"`
	Name        string   `json:"name"`
	InstanceIDs []string `json:"instanceIds"`
}

func handler(ctx context.Context, req Request) (string, error) {
	cfg, err := config.LoadDefaultConfig(context.Background())
	checkError(err)

	client := ec2.NewFromConfig(cfg)
	input := &ec2.DescribeInstancesInput{InstanceIds: req.InstanceIDs}

	result, err := client.DescribeInstances(context.Background(), input)
	checkError(err)

	var publicIPs []string
	for _, reservation := range result.Reservations {
		for _, instance := range reservation.Instances {
			if instance.PublicIpAddress != nil {
				publicIPs = append(publicIPs, *instance.PublicIpAddress)
			}
		}
	}

	session := session.Must(session.NewSession())

	r53 := route53.New(session)
	ip := strings.Join(publicIPs, ", ")
	zoneID := aws.String(req.ZoneId)
	ipAddress := aws.String(ip)
	recordAction := aws.String("UPSERT")
	recordName := aws.String(req.Name)
	recordType := aws.String("A")
	recordTTL := aws.Int64(300)

	changeInput := &route53.ChangeResourceRecordSetsInput{
		HostedZoneId: zoneID,
		ChangeBatch: &route53.ChangeBatch{
			Changes: []*route53.Change{
				{
					Action: recordAction,
					ResourceRecordSet: &route53.ResourceRecordSet{
						Name: recordName,
						Type: recordType,
						TTL:  recordTTL,
						ResourceRecords: []*route53.ResourceRecord{
							{Value: ipAddress},
						},
					},
				},
			},
		},
	}

	r53.ChangeResourceRecordSets(changeInput)

	return fmt.Sprintf("Public IP addresses of instances: %v", publicIPs), nil
}

func main() {
	lambda.Start(handler)
}
