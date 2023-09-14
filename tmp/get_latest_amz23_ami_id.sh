#!/bin/bash

AMI_NAME="/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"

AMI_ID=$(aws --no-cli-auto-prompt ssm get-parameter --name $AMI_NAME --query "Parameter.Value" --output text)
echo "\"$AMI_ID\""
