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

IFS=$'\n'
for SERVICE_ARR in $(ssh -o "StrictHostKeyChecking no" $SWARM_ADM docker service ls | grep " 0/1 " )
do
    echo ${SERVICE_ARR}
done
echo "total $(ssh -o "StrictHostKeyChecking no" $SWARM_ADM docker service ls | grep " 0/1 " | wc -l)"