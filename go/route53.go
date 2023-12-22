package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/route53"
	"github.com/aws/aws-sdk-go-v2/service/route53/types"
)

func checkError(message string, err error) {
	if err != nil {
		fmt.Printf("%v\n%v", message, err)
	}
}

type data struct {
	name   string
	ttl    int64
	ip     string
	zoneid string
	action string
}

func updateDns(ctx context.Context, val *data) {

	cfg, err := config.LoadDefaultConfig(ctx, config.WithSharedConfigProfile("pranshu"))
	checkError("Could not load the configuration.", err)

	client := route53.NewFromConfig(cfg)

	output, err := client.ChangeResourceRecordSets(ctx, &route53.ChangeResourceRecordSetsInput{
		HostedZoneId: &val.zoneid,
		ChangeBatch: &types.ChangeBatch{
			Changes: []types.Change{
				{
					Action: types.ChangeAction(val.action),
					ResourceRecordSet: &types.ResourceRecordSet{
						Name: &val.name,
						Type: types.RRTypeA,
						TTL:  &val.ttl,
						ResourceRecords: []types.ResourceRecord{
							{Value: &val.ip},
						},
					},
				},
			},
		},
	},
	)
	checkError("Could not update the record.", err)

	fmt.Printf("Change status: %v\n", output.ChangeInfo.Status.Values())
}

func main() {
	changeVal := &data{
		name:   "paulpranshu.xyz",
		ttl:    3600,
		ip:     "192.168.1.100",
		zoneid: "Z014611832PD0HCGBA9SF",
		action: "UPSERT",
	}

	updateDns(context.TODO(), changeVal)
}
