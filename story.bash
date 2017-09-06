tag_key=$(config tag_key)
tag_value=$(config tag_value)

aws ec2 describe-instances --filters Name=tag:$tag_key,Values=$tag_value \
--query 'Reservations[*].Instances[*].{ ID:InstanceId,St:State,Time:LaunchTime,IP:PrivateIpAddress,Tags:Tags }'

