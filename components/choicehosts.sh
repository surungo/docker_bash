#!/bin/bash

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

#   CHOICE HOST
HOSTS=($(ssh -o "StrictHostKeyChecking no" $SWARM_ADM  docker node ls --format "{{.Hostname}}"))
for i in ${!HOSTS[@]}; do
  echo "    Choice $i is ${HOSTS[$i]}"
done
echo ""
echo " Choice a number of manager:"	
echo -n "Number:  "
read OPTION_HOSTS_NUMBER
HOST="${HOSTS[$OPTION_HOSTS_NUMBER]}"
echo "SWARM_ADM: $HOST"



