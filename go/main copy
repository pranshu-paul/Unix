package main

import (
	"context"
	"fmt"
	"log"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
	"github.com/aws/aws-sdk-go-v2/service/route53"
	"github.com/aws/aws-sdk-go-v2/service/route53/types"
)

type data struct {
	Name       string   `json:"name"`
	Ttl        int64    `json:"ttl"`
	InstanceId []string `json:"instanceId"`
	ZoneId     string   `json:"zoneId"`
	Action     string   `json:"action"`
}

func checkError(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

func (val *data) updateDns(ctx context.Context) (string, error) {
	cfg, err := config.LoadDefaultConfig(ctx, config.WithSharedConfigProfile("pranshu"))
	checkError(err)

	ec2_client := ec2.NewFromConfig(cfg)

	result, err := ec2_client.DescribeInstances(ctx, &ec2.DescribeInstancesInput{
		InstanceIds: val.InstanceId,
	})
	checkError(err)

	if result.Reservations[0].Instances[0].PublicIpAddress == nil {
		log.Fatal("The instance does not have a public IP address.")
	}

	ip := result.Reservations[0].Instances[0].PublicIpAddress

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
					ResourceRecords: []types.ResourceRecord{{
						Value: ip,
					}},
				},
			}},
		},
	})
	checkError(err)

	return fmt.Sprintf("Change status: %v\n", output.ChangeInfo.Status.Values()), nil
}

func main() {
	values := &data{
		Name:       "paulpranshu.xyz",
		Ttl:        3600,
		ZoneId:     "Z014611832PD0HCGBA9SF",
		Action:     "UPSERT",
		InstanceId: []string{"i-0a1668a1a4a53fbef"},
	}

	values.updateDns(context.Background())
}
