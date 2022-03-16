#!/bin/bash
SERVICE_NAME=$1
SWARM_ADM=$2


if [ -z "$SERVICE_NAME" ] 
then
    echo " "
    echo " parameters  servicename "
    echo " ./changehostcontainer.sh prod-service " 
    echo " "
    echo " "
    exit
fi

if [ -z "$SWARM_ADM" ] 
then
#get manager
. "../fun_get_manager.sh"
fi

#echo "ssh $SWARM_ADM docker service ps $SERVICE_NAME"
echo "node: $SERVICE_NAME"
NODES=($(ssh -o "StrictHostKeyChecking no" "$SWARM_ADM" docker service ps -f "desired-state=Running" --format "{{.Node}}" "$SERVICE_NAME"))


for i in ${!NODES[@]}; do
  echo "    Choice $i is ${NODES[$i]}"
done
read OPTION_NUMBER
NODE=${NODES[$OPTION_NUMBER]}
echo "node: $NODE"
echo " "

echo "ssh $SWARM_ADM docker service update --constraint-add node.hostname!=$NODE $SERVICE_NAME"
ssh -o "StrictHostKeyChecking no" $SWARM_ADM docker service update --constraint-add node.hostname!=$NODE $SERVICE_NAME
echo "sleep 3"
sleep 3
echo "ssh $SWARM_ADM docker service update --constraint-rm node.hostname!=$NODE $SERVICE_NAME"
ssh -o "StrictHostKeyChecking no" $SWARM_ADM docker service update --constraint-rm node.hostname!=$NODE $SERVICE_NAME
echo " "
ssh -o "StrictHostKeyChecking no" "$SWARM_ADM" docker service ps -f "desired-state=Running" "$SERVICE_NAME"

echo "[the end]"
