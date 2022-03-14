#!/bin/bash
SERVICE_NAME=$1
SWARM_ADM=$2


if [ -z "$SERVICE_NAME" ] 
then
    echo " "
    echo " parameters  servicename "
    echo " ./addconstraintwork.sh prod-service " 
    echo " "
    echo " "
    exit
fi

if [ -z "$SWARM_ADM" ] 
then
#get manager
. "../fun_get_manager.sh"
fi

echo "ssh $SWARM_ADM docker service update --constraint-add node.role==worker $SERVICE_NAME"
ssh -o "StrictHostKeyChecking no" $SWARM_ADM docker service update --constraint-add node.role==worker "$SERVICE_NAME"
ssh -o "StrictHostKeyChecking no" "$SWARM_ADM" docker service ps -f "desired-state=Running" "$SERVICE_NAME"


echo "[the end]"


