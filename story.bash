tag_key=$(config tag_key)
tag_value=$(config tag_value)

aws ec2 describe-instances --filters Name=tag:$tag_key,Values=$tag_value \
--query 'Reservations[*].Instances[*].{ ID:InstanceId,St:State,Time:LaunchTime,IP:PrivateIpAddress,Tags:Tags }' | perl -n -MJSON -e '
$json.=$_;
  END {
    my $ii = decode_json($json);
    for $i (map {$_->[0]} @$ii){
      write();
    }
  }

format STDOUT_TOP  =

ID                        IP                  Time                  State
-------------------------------------------------------------------------
.

format STDOUT  =
@<<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<< @>>>>>>>>>>>>>>>>>>   @>>>>>>>>>>>>>>> ~
$i->{ID},  $i->{IP}||'Null', $i->{Time}, join "/", ($i->{St}{Code}, $i->{St}{Name})
.

'

