#!/bin/bash

#echo "choiceservice.sh"

#LOAD CONSTANTS
if [ -z "$V_SWARM_ADM_ARRAY" ] || [ -z "$V_FILTER_GREP_ENV" ] || [ -z "$V_CANCEL" ]  
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

#   CHOICE HOST
if [ -z "$HOST" ] 
then
    FILE=./choicehosts.sh
    if [[ -f "$FILE" ]]; then
        . "${FILE}"
    fi
    FILE=./components/choicehosts.sh
    if [[ -f "$FILE" ]]; then
        . "${FILE}"
    fi
fi
##echo "ssh -o \"StrictHostKeyChecking no\" $HOST  docker ps --format \"{{.Names}}\" | cut -d \".\" -f 1 | sort | uniq | grep \"${V_FILTER_GREP_ENV}\" "
#   CHOICE SERVICE
V_CONTAINERS=("${V_CANCEL}" $(ssh -o "StrictHostKeyChecking no" $HOST  docker ps --format "{{.Names}}" | cut -d "." -f 1 | sort | uniq | grep "${V_FILTER_GREP_ENV}"))
for i in ${!V_CONTAINERS[@]}; do
  #STATUS_S=$(ssh -o "StrictHostKeyChecking no" $SWARM_ADM docker service ps -f "desired-state=Running" --format "{{.DesiredState}}" ${V_CONTAINERS[$i]} | uniq )
  echo "    Choice $i is ${V_CONTAINERS[$i]}  "
done
echo ""
echo " Choice a number of container:"	
echo -n "Number:  "
read OPTION_V_CONTAINER_NUMBER

SERVICE_NAME="${V_CONTAINERS[$OPTION_V_CONTAINER_NUMBER]}"
if [ "${SERVICE_NAME}" == "${V_CANCEL}" ]
then
    echo "Process canceled"
    exit
fi
# LABELS=$(ssh -o "StrictHostKeyChecking no" $HOST docker inspect -f "{{.Config.Labels}}" $CONTAINER_NAME)
# LABELS=${LABELS#map*service.name:}
# SERVICE_NAME=${LABELS% com.docker.swarm.task:*]}
echo "SERVICE_NAME: $SERVICE_NAME"



