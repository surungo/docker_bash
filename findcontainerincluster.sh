#!/bin/bash
SERVICE_NAME=$1
SWARM_ADM=$2
V_REGISTRY_UR1=
V_REGISTRY_UR2=
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

echo -n " Filter for:"	
read filter

echo "filter ${filter}"

for i in $(ssh   -o "StrictHostKeyChecking no" "$SWARM_ADM" docker node ls --format "{{.Hostname}}" )
do
  HOST=$i
  echo "$HOST"
  #echo "ssh  -o StrictHostKeyChecking no $HOST docker ps | grep ${filter}" 
  ssh  -o "StrictHostKeyChecking no" "$HOST" docker ps -a | grep "${filter}" 
done

echo "[the end]"



