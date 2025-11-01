package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

func checkError(err error) {
	if err != nil {
		panic(err)
	}
}

func main() {

	profileName := "pranshu"

	cfg, err := config.LoadDefaultConfig(context.Background(), config.WithSharedConfigProfile(profileName))
	checkError(err)

	client := s3.NewFromConfig(cfg)

	bucket_name := "oswebadmin"

	bucket := &s3.ListObjectsV2Input{Bucket: &bucket_name}

	output, err := client.ListObjectsV2(context.Background(), bucket)
	checkError(err)

	fmt.Println("results:")
	for _, object := range output.Contents {
		fmt.Printf("key=%s size=%d", object.Key, object.Size)
	}
}
