#!/bin/bash

#echo "choicehosts.sh"

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

if [ -z "$HOST" ] 
then

    #   CHOICE 
    # echo "ssh -o \"StrictHostKeyChecking no\" $SWARM_ADM  docker node ls --format \"{{.Hostname}}\" "
    HOSTS_AUX=($(ssh -o "StrictHostKeyChecking no" $SWARM_ADM  docker node ls --format "{{.Hostname}}"))
    INDEX_PREV=0
    for i in ${!HOSTS_AUX[@]}; do
        
        HOST_ID=$(echo "${HOSTS_AUX[$i]}" | sed "s/poa01dck//g" | cut -f1 -d'.' )
        HOST_ID=$(echo "$HOST_ID" | sed "s/d//g" )
        HOST_ID=$(echo "$HOST_ID" | sed "s/e//g" )
        HOST_ID=$(expr $HOST_ID + 0 )
        #echo " TEST $HOST_ID is ${HOSTS_AUX[$i]} "
        HOSTS[$HOST_ID]=${HOSTS_AUX[$i]}
        INDEX_PREV=$HOST_ID
    done
    HOSTS[0]="${V_CANCEL}"
    if [[ "${SHOW_ALL}" == "true" ]]
    then
        HOSTS_ALL_POS=$(expr $INDEX_PREV + 1 )
        HOSTS[$HOSTS_ALL_POS]="${V_ALL}"
    fi
    for i in ${!HOSTS[@]}; do
        echo "    Choice $i is ${HOSTS[$i]}"
    done
    echo ""
    echo " Choice a number of host:"	
    echo -n "Number:  "
    read OPTION_HOSTS_NUMBER
    HOST="${HOSTS[$OPTION_HOSTS_NUMBER]}"

    if [ "${HOST}" == "${V_CANCEL}" ]
    then
        echo "Process canceled"
        exit
    fi
fi    
echo "HOST: $HOST"



