#!/bin/bash
SWARM_ADM=$1
HOST=$2
SERVICE_NAME=$3

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

#FILTER

for HOST in $(ssh -o "StrictHostKeyChecking no" $SWARM_ADM docker node ls -f "role=manager" --format "{{.Hostname}}")
do
    echo "### $HOST ### "
    for CONTAINER_ID in $(ssh -o "StrictHostKeyChecking no" ${HOST} docker ps | grep 'pucrs.br' | awk '{print $1}')
    do
        ssh -o "StrictHostKeyChecking no" $HOST docker inspect -f "{{.Name}}" $CONTAINER_ID
        ssh -o "StrictHostKeyChecking no" $HOST docker exec $CONTAINER_ID 'java -version'
        ssh -o "StrictHostKeyChecking no" $HOST docker exec $CONTAINER_ID 'find . -print | grep ojdbc6'
        echo "-----"
    done
done

echo "[the end]"
