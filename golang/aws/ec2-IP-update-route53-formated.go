package main

import (
	"context"
	"fmt"
	"strings"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/route53"
)

func checkError(err error) {
	if err != nil {
		panic(err)
	}
}

func setRecord(instanceIDs []string, zoneid string, name string, action string) []string {

	cfg, err := config.LoadDefaultConfig(context.Background(), config.WithSharedConfigProfile("pranshu"))
	checkError(err)

	client := ec2.NewFromConfig(cfg)
	input := &ec2.DescribeInstancesInput{InstanceIds: instanceIDs}

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

	resourceRecord := &route53.ResourceRecord{Value: &ip}
	resourceRecords := []*route53.ResourceRecord{resourceRecord}

	record := "A"
	var ttl int64 = 300
	resourceRecordSet := &route53.ResourceRecordSet{
		Name:            &name,
		Type:            &record,
		TTL:             &ttl,
		ResourceRecords: resourceRecords,
	}

	change := &route53.Change{
		Action:            &action,
		ResourceRecordSet: resourceRecordSet,
	}

	changeValue := []*route53.Change{change}
	changeBatchVal := &route53.ChangeBatch{Changes: changeValue}

	changeInput := &route53.ChangeResourceRecordSetsInput{
		HostedZoneId: &zoneid,
		ChangeBatch:  changeBatchVal,
	}

	r53.ChangeResourceRecordSets(changeInput)

	return publicIPs
}

func main() {
	zoneid := "Z014611832PD0HCGBA9SF"
	name := "paulpranshu.xyz"
	instanceIDs := []string{"i-09d289e8a50e86f64"}
	action := "DELETE"

	publicIPs := setRecord(instanceIDs, zoneid, name, action)

	fmt.Printf("A record of domain %q has been %vd with IP address %v of instance %q\n", name, strings.ToLower(action), publicIPs, instanceIDs[:])
}
