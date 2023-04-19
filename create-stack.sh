#!/bin/bash
if [ -z "$1" ]; then
    echo "Wrong parameter 1 MODE null"
    exit 1 
elif [ "$1" == "EKS_EC2" ]; then
      MODE=$1
elif [ "$1" == "EKS_FARGATE" ]; then
      MODE=$1
elif [ "$1" == "ECS_EC2" ]; then
      MODE=$1
elif [ "$1" == "ECS_FARGATE" ]; then
      MODE=$1 
elif [ "$1" == "EC2" ]; then
      MODE=$1
elif [ "$1" == "EC2_DOCKER" ]; then
      MODE=$1             
else
    echo "Wrong parameter 1 MODE: "$1
    exit 1 
fi




region=$(aws configure get region)


if [ "$MODE" == "ECS_FARGATE" ] || [ "$MODE" == "ECS_EC2" ] || [ "$MODE" == "EC2" ] || [ "$MODE" == "EC2_DOCKER" ]; then

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

elif [ "$MODE" == "EKS_EC2" ] || [ "$MODE" == "EKS_FARGATE" ]; then

  aws cloudformation create-stack --region $region  --stack-name vpc-eks-stack --template-body file://./eks-vpc.yaml --capabilities CAPABILITY_NAMED_IAM #--on-failure DO_NOTHING 
  result=$?

  if [ $result -eq 254 ] || [ $result -eq 255 ]; then
    echo "vpc-eks-stack already exists"
    #exit 0
  elif [ $result -ne 0 ]; then
    echo "vpc-eks-stackfailed to create " $result
    exit 1
  fi

  aws cloudformation wait stack-create-complete --region $region --stack-name vpc-eks-stack


fi