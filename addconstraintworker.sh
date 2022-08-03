#!/bin/bash

SERVICE_NAME=$1

function addWorker(){

    echo "ssh $SWARM_ADM docker service update --constraint-add node.role==worker $SERVICE_NAME"
    ssh -o "StrictHostKeyChecking no" $SWARM_ADM docker service update --constraint-add node.role==worker "$SERVICE_NAME"
    ssh -o "StrictHostKeyChecking no" "$SWARM_ADM" docker service ps -f "desired-state=Running" "$SERVICE_NAME"
}
 
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

echo "ssh -o \"StrictHostKeyChecking no\" $SWARM_ADM docker node ls -f \"role=manager\" --format \"{{.Hostname}}\""
for HOST in $(ssh -o "StrictHostKeyChecking no" $SWARM_ADM docker node ls -f "role=manager" --format "{{.Hostname}}")
do
    echo "ssh -o \"StrictHostKeyChecking no\" ${HOST} docker ps | grep \"$V_REGISTRY_BASE\" | awk \'{print \$1}\' "
    for CONTAINER_NAME in $(ssh -o "StrictHostKeyChecking no" ${HOST} docker ps | grep "$V_REGISTRY_BASE" | awk '{print $1}')
    do
        LABELS=$(ssh -o "StrictHostKeyChecking no" $HOST docker inspect -f "{{.Config.Labels}}" $CONTAINER_NAME)
        LABELS=${LABELS#map*service.name:}
        SERVICE_NAME=${LABELS% com.docker.swarm.task:*]}
        echo "SERVICE_NAME: $SERVICE_NAME"
        addWorker
    done
done

echo "[the end]"


