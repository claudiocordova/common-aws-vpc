#!/bin/bash

region=$(aws configure get region)

aws cloudformation create-stack --region $region  --stack-name vpc-stack --template-body file://./vpc.yaml --capabilities CAPABILITY_NAMED_IAM #--on-failure DO_NOTHING 
result=$?

if [ $result -eq 254 ] || [ $result -eq 255 ]; then
  echo "vpc-stack already exists"
  #exit 0
elif [ $result -ne 0 ]; then
  echo "vpc-stack failed to create " $result
  exit 1
fi

aws cloudformation wait stack-create-complete --region $region --stack-name vpc-stack
