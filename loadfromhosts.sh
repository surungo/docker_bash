#!/bin/bash

echo ""
echo ""
#LOAD CONSTANTS
if [ -z "$V_SWARM_ADM_ARRAY" ] 
then

    FILE=../../fun_get_constants.sh
    if [[ -f "$FILE" ]]; then
        . "${FILE}"
    fi

    FILE=../fun_get_constants.sh
    if [[ -f "$FILE" ]]; then
        . "${FILE}"
    fi

fi

#CHOICE MANAGER
if [ -z "$SWARM_ADM" ] 
then

    FILE=./choicecluster.sh
    if [[ -f "$FILE" ]]; then
        . "${FILE}"
    fi

    FILE=./components/choicecluster.sh
    if [[ -f "$FILE" ]]; then
        . "${FILE}"
    fi

fi

for HOST in $(ssh -o "StrictHostKeyChecking no" $SWARM_ADM  docker node ls --format "{{.Hostname}}")
do
  v_totaldisk=$(ssh -o "StrictHostKeyChecking no" $HOST df -l -h --total | grep total | sed "s/total                  /total disk/g")
  v_uptime=$(ssh -o "StrictHostKeyChecking no" $HOST uptime)
  v_total=$(ssh -o "StrictHostKeyChecking no" $HOST docker ps | wc -l )    #|  grep -c ""  
  v_uptime=$(echo "${v_uptime}" | sed "s/  0 users, //g")
  echo "${HOST} - ${v_total} container up - ${v_totaldisk}${v_uptime} "
done
		
