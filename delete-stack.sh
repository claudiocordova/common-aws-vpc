#!/bin/bash

region=$(aws configure get region)

aws cloudformation delete-stack --region $region --stack-name vpc-stack

if [ $? -ne 0 ]; then
  echo "Failed to delete vpc-stack"
  exit 1
fi


aws cloudformation wait stack-delete-complete --region $region --stack-name vpc-stack

