package main

import (
	"context"
	"fmt"
	"strings"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
	"github.com/aws/aws-sdk-go-v2/service/ec2/types"
	"github.com/aws/aws-sdk-go-v2/service/route53"
)

func checkError(err error) {
	if err != nil {
		panic(err)
	}
}

type changeRecord struct {
	zoneid      string
	name        string
	action      string
	instanceIds []string
	record      string
	ttl         int64
}

func setRecord(data *changeRecord) []string {

	cfg, err := config.LoadDefaultConfig(context.Background(), config.WithSharedConfigProfile("pranshu"))
	checkError(err)

	client := ec2.NewFromConfig(cfg)
	input := &ec2.DescribeInstancesInput{InstanceIds: data.instanceIds}

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

	r53 := route53.NewFromConfig(cfg)
	ip := strings.Join(publicIPs, ", ")

	r53.ChangeResourceRecordSets(context.Background(), &route53.ChangeResourceRecordSetsInput{
		HostedZoneId: &data.zoneid,
		ChangeBatch: &types.ChangeBatch{
			Changes: []route53.Change{
				Action: data.action,
				ResourceRecordSet: &route53.ResourceRecordSet{
					Name:            &data.name,
					Type:            &data.record,
					TTL:             &data.ttl,
					ResourceRecords: []*route53.ResourceRecord{},
				},
			},
		},
	},
	)

	return publicIPs
}

func main() {

	changeVal := &changeRecord{
		zoneid:      "Z014611832PD0HCGBA9SF",
		name:        "paulpranshu.xyz",
		instanceIds: []string{"i-09d289e8a50e86f64"},
		action:      "UPSERT",
		record:      "A",
		ttl:         3600,
	}

	publicIPs := setRecord(changeVal)

	fmt.Printf("An action %q has been taken on the record %q of the domain %q with the IP address %v of the instance %q\n", changeVal.action, changeVal.record, changeVal.name, publicIPs, changeVal.instanceIds[:])
}
