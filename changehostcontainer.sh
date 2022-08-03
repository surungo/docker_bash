#!/bin/bash
SWARM_ADM=$1
HOST=$2
SERVICE_NAME=$3
 
#CHOICE service
if [ -z "$SERVICE_NAME" ] 
then

    FILE=./choiceservice.sh
    if [[ -f "$FILE" ]]; then
        . "${FILE}"
    fi

    FILE=./components/choiceservice.sh
    if [[ -f "$FILE" ]]; then
        . "${FILE}"
    fi

fi

NODE=$HOST

echo "ssh -o \"StrictHostKeyChecking no\" $SWARM_ADM docker service update --constraint-add node.hostname!=$NODE $SERVICE_NAME"
ssh -o "StrictHostKeyChecking no" $SWARM_ADM docker service update --constraint-add node.hostname!=$NODE $SERVICE_NAME
echo "sleep 3"
sleep 3
echo "ssh -o \"StrictHostKeyChecking no\" $SWARM_ADM docker service update --constraint-rm node.hostname!=$NODE $SERVICE_NAME"
ssh -o "StrictHostKeyChecking no" $SWARM_ADM docker service update --constraint-rm node.hostname!=$NODE $SERVICE_NAME
echo " "
ssh -o "StrictHostKeyChecking no" "$SWARM_ADM" docker service ps -f "desired-state=Running" "$SERVICE_NAME"

SERVICE_NAME=""

read -p "Do you want repeat process? (y/n) " yn

case $yn in  
	y ) echo ok, we will proceed & ./changehostcontainer.sh "${SWARM_ADM}" "${HOST}";;
         
	n ) echo exiting...;
		exit;;
	* ) echo invalid response;
		exit 1;;
esac

echo "[the end]"
