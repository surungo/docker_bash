#!/bin/bash

echo ""
echo ""
. "../fun_get_constants.sh"

for i in ${!V_SWARM_ADM_ARRAY[@]}; do
  echo "    Choice $i is ${V_SWARM_ADM_ARRAY[$i]}"
done
echo ""
echo " Choice a number:"	
echo -n "Number:  "
read OPTION_NUMBER

SWARM_ADM="${V_SWARM_ADM_ARRAY[$OPTION_NUMBER]}"
echo "SWARM_ADM: $SWARM_ADM"
for HOST in $(ssh -o "StrictHostKeyChecking no" $SWARM_ADM  docker node ls --format "{{.Hostname}}")
do
	v_uptime=$(ssh -o "StrictHostKeyChecking no" $HOST uptime)
    v_total=$(ssh -o "StrictHostKeyChecking no" $HOST docker ps | wc -l )    #|  grep -c ""  
    echo "${HOST} - ${v_uptime} -  ${v_total} container number"
done
		
