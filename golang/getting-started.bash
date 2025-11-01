# Initialize a Go module named "lambda"
go mod init lambda

# Clean up and adjust module dependencies
go mod tidy

# Download the AWS SDK for EC2
go get github.com/aws/aws-sdk-go-v2/service/ec2

# Access documentation for the "context.TODO" default package
go doc context.TODO

# Access help for the entire EC2 service package
go doc github.com/aws/aws-sdk-go-v2/service/ec2

# Access help for the "DescribeInstances" method of the EC2 service
go doc github.com/aws/aws-sdk-go-v2/service/ec2.DescribeInstances

# Access help for the configuration loading function
go doc github.com/aws/aws-sdk-go-v2/config.LoadDefaultConfig

# To create an executable in windows.
# Name the file main.go
go build -o <output>.exe