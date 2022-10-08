scp file user@host:dir

SERVER=cccccje.com
USERVER=ubuntu@$SERVER

ssh -i "$HOME/secret/key-pair-1.pem" $USERVER
scp -i "$HOME/secret/key-pair-1.pem"  \
    /home/me/Templates/lrn/python/dj/https_site_v2 \
    $USERVER:/home/ubuntu/ \

scp -i "$HOME/secret/key-pair-1.pem"  \
    /home/me/Templates/lrn/h5/Todo/compose-from-hub.yml\
        $USERVER:/home/ubuntu/app/docker-compose.yml 

# on the server
sudo apt install docker-compose docker.io
sudo docker-compose --file compose-from-hub.yml up

# on the client
# curl $SERVER:9002/hi/
# curl $SERVER:8001/hi/
curl https://$SERVER/todo/hi/
curl https://$SERVER/auth/hi/


# Get the Tag, State, Id and Public Ip
aws ec2 describe-instances \
    --filters "Name=instance-type,Values=t2.micro" \
    --query "Reservations[].Instances[].[Tags[].Value, State.Name, InstanceId, PublicIpAddress][]"

# Get the Tag of all ecs instances
aws ec2 describe-instances \
    --filters "Name=instance-type,Values=t2.micro" \
    --query "Reservations[].Instances[].Tags[]"

# get the instance id
aws ec2 describe-instances \
    --filters "Name=instance-type,Values=t2.micro" \
    --query "Reservations[].Instances[].InstanceId"

# start and stop instance
id=i-013de5a157d8d6e93
aws ec2 stop-instances --instance-ids $id
aws ec2 start-instances --instance-ids $id

# Get the elastic ip
aws ec2 describe-addresses \
    --query "Addresses[].[Tags[].Value, PublicIp][]"

ip=52.0.38.184
# Associate an address, no output if succeeded.
aws ec2 associate-address --instance-id $id --public-ip $ip


