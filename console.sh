#!/bin/bash

CLUSTER=$1
SERVICE=$2

if [ -z "$CLUSTER" -o -z "$SERVICE" ]; then
  echo "Usage:"
  echo "ecs-console cluster-name service-name"
  exit 1
fi

TASK_ID=$( aws ecs list-tasks --cluster=$CLUSTER --service-name=$SERVICE --output json | jq -r '.taskArns[0]' )
CONTAINER_INSTANCE_ID=$( aws ecs describe-tasks --cluster=$CLUSTER --tasks $TASK_ID --output json | jq -r '.tasks[0].containerInstanceArn' )
EC2_INSTANCE=$( aws ecs describe-container-instances --cluster=staging --container-instances $CONTAINER_INSTANCE_ID --output json | jq -r '.containerInstances[0].ec2InstanceId' )
EC2_IP=$( aws ec2 describe-instances --instance-ids $EC2_INSTANCE --output json | jq -r '.Reservations[0].Instances[0].PublicIpAddress' )

echo Connecting to: $EC2_IP

ssh -i $ECS_PEM_FILE ec2-user@$EC2_IP -t 'bash -c "docker exec -it $( docker ps -a -q -f name=ecs-'$SERVICE' | head -n 1 ) bash"'
