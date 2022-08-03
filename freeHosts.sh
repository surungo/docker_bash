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
  echo $HOST
  ssh -o "StrictHostKeyChecking no" $HOST  free -h
  echo "--------------------------------------------------------------------------------"
done
		
