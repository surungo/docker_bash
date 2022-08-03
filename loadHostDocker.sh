#!/bin/bash
 
#   CHOICE HOST
. "./components/choicehosts.sh"

echo "SWARM_ADM: $SWARM_ADM"

#du -ch /var/lib/docker/containers/*/*-json.log
#truncate -s 0 /var/lib/docker/containers/*/*-json.log

#ls -la /var/lib/docker/overlay2/ | wc -l
#du -sh /var/lib/docker/overlay2
#du -shc /var/lib/docker/overlay2/*/diff
#df -h /dev/sd*

echo "ssh -o \"StrictHostKeyChecking no\" $HOST docker system df -v"
ssh -o "StrictHostKeyChecking no" $HOST docker system df -v

echo "ssh -o \"StrictHostKeyChecking no\" $HOST docker system df "
ssh -o "StrictHostKeyChecking no" $HOST docker system df 

echo "[the end]"
