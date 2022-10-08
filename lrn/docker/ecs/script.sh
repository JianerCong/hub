# Attach the task execution role policy:
# aws iam --region us-east-1 attach-role-policy \
#     --role-name ecsTaskExecutionRole \
#     --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy

# # Create a cluster config
# ecs-cli configure --cluster tutorial-cluster \
#         --default-launch-type FARGATE \
#         --config-name tutorial \
#         --region us-east-1

# # Create a cli-profile
# AWS_ACCESS_KEY_ID=AKIASKHREMFIIJ4EJDVZ
# AWS_SECRET_ACCESS_KEY=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
# ecs-cli configure profile \
#         --access-key $AWS_ACCESS_KEY_ID \
#         --secret-key $AWS_SECRET_ACCESS_KEY \
#         --profile-name tutorial-profile


# # Create an Amazon ECS cluster
# ecs-cli up --cluster-config tutorial \
#         --ecs-profile tutorial-profile
# # Make a note of these VPC and subnet IDs as you will need them in the following steps.
# # VPC created: vpc-0b5dc9a0d4c84a434
# # Subnet created: subnet-0ea23ee5577b5a370
# # Subnet created: subnet-06330e0972973da36
# SUBNET_ID1=subnet-0ea23ee5577b5a370
# SUBNET_ID2=subnet-06330e0972973da36
# VPC_ID=vpc-0b5dc9a0d4c84a434


# # get the security group ID
# aws ec2 describe-security-groups \
#     --filters Name=vpc-id,Values=$VPC_ID \
#     --region us-east-1
# SECURITY_GROUP_ID=sg-0a202e651cf8e4682

# # add a security group rule to allow inbound access on port 80
# aws ec2 authorize-security-group-ingress \
#     --group-id $SECURITY_GROUP_ID --protocol tcp \
#     --port 80 --cidr 0.0.0.0/0 --region us-east-1

# ecs-cli compose --project-name tutorial-project \
#         --file compose.yml \
#         service up \
#         --create-log-groups --cluster-config tutorial \
#         --ecs-profile tutorial-profile

# INFO[0001] Using ECS task definition                     TaskDefinition="tutorial-project:1"
# INFO[0001] Created Log Group tutorial in us-east-1      
# INFO[0001] Auto-enabling ECS Managed Tags               
# INFO[0008] (service tutorial-project) has started 1 tasks: (task 09ddc51f2a6f471da46663b53f786a22).  timestamp="2022-08-26 14:47:47 +0000 UTC"
# INFO[0034] Service status                                desiredCount=1 runningCount=1 serviceName=tutorial-project
# INFO[0034] ECS Service has reached a stable state        desiredCount=1 runningCount=1 serviceName=tutorial-project
# INFO[0034] Created an ECS service                        service=tutorial-project taskDefinition="tutorial-project:1"

# ecs-cli compose --file compose.yml \
#         --project-name tutorial-project service ps \
#         --cluster-config tutorial --ecs-profile tutorial-profile
# # note the task id
# TASK_ID=09ddc51f2a6f471da46663b53f786a22

# ecs-cli logs --task-id $TASK_ID \
#         --follow --cluster-config tutorial \
#         --ecs-profile tutorial-profile

# turn down the service
ecs-cli compose --file compose.yml --project-name tutorial-project \
        service down \
        --cluster-config tutorial \
        --ecs-profile tutorial-profile
# take down the cluster
ecs-cli down --force \
        --cluster-config tutorial \
        --ecs-profile tutorial-profile
