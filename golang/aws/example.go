func (ec2Handler *EC2Handler) StartInstance(ctx context.Context) (err error) {
    instanceId := "i-0b33f0e5d8d00d6f3" // list your instances here, if you want to have a list instead of 1 instance. You may need to update the input from InstanceIds: []string{instanceId} to InstancedIds: instanceIds and rename the variable to instanceIds also do some changes in the for loop.
    cfg, err := config.LoadDefaultConfig(ctx)
    if err != nil {
        log.Fatal(err)
    }
    ec2Client := ec2.NewFromConfig(cfg)
    input := &ec2.DescribeInstanceStatusInput{
        InstanceIds: []string{instanceId},
    }
    output, err := ec2Client.DescribeInstanceStatus(ctx, input)
    if err != nil {
        log.Println(err)
        return
    }
    isRunning := false
    for _, instanceStatus := range output.InstanceStatuses {
        log.Printf("%s: %s\n", *instanceStatus.InstanceId, instanceStatus.InstanceState.Name)
        if *instanceStatus.InstanceId == instanceId && instanceStatus.InstanceState.Name == "running" {
            isRunning = true
        }
    }
    if !isRunning {
        runInstance := &ec2.StartInstancesInput{
            InstanceIds: []string{instanceId},
        }
        log.Printf("Start %s", instanceId)
        if outputStart, errInstance := ec2Client.StartInstances(ctx, runInstance); errInstance != nil {
            return
        } else {
            log.Println(outputStart.StartingInstances)
        }
    } else {
        log.Printf("Skip starting %s", instanceId)
    }
    return
}


/// Stoppping an instance
func (ec2Handler *EC2Handler) StopInstance(ctx context.Context) (err error) {
    instanceId := "i-0b33f0e5d8d00d6f3"
    cfg, err := config.LoadDefaultConfig(ctx)
    if err != nil {
        log.Fatal(err)
    }
    ec2Client := ec2.NewFromConfig(cfg)
    input := &ec2.DescribeInstanceStatusInput{
        InstanceIds: []string{instanceId},
    }
    output, err := ec2Client.DescribeInstanceStatus(ctx, input)
    if err != nil {
        log.Println(err)
        return
    }
    isStop := false
    for _, instanceStatus := range output.InstanceStatuses {
        log.Printf("%s: %s\n", *instanceStatus.InstanceId, instanceStatus.InstanceState.Name)
        if *instanceStatus.InstanceId == instanceId && instanceStatus.InstanceState.Name == "stop" {
            isStop = true
        }
    }
    if !isStop {
        stopInstance := &ec2.StopInstancesInput{
            InstanceIds: []string{instanceId},
        }
        log.Printf("Stop %s", instanceId)
        if outputStop, errInstance := ec2Client.StopInstances(ctx, stopInstance); errInstance != nil {
            return
        } else {
            log.Println(outputStop.StoppingInstances)
        }
    } else {
        log.Printf("Skip stop %s", instanceId)
    }
    return
}