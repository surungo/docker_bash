#!/bin/bash

comando="logs.sh"

SERVICE_NAME=$1

if [ -z "$SERVICE_NAME" ]
then
    echo " "
    echo " Exemplo "
	  echo " ./${comando} prod-ws-servico " 
    echo " "
    echo " "
    exit
fi
if [ -z "$SWARM_ADM" ] 
then
#get manager entrada$SERVICE_NAME
. "../fun_get_manager.sh"
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

for vhost in $(ssh -o "StrictHostKeyChecking no" "$SWARM_ADM"  docker service ps "$SERVICE_NAME" | grep Running | awk '{print $4}')
do
  HOST=$vhost
  echo "HOST $HOST"
  for vtask in $(ssh -o "StrictHostKeyChecking no" "$SWARM_ADM" docker service ps "$SERVICE_NAME" | grep Running | awk '{print $1}')
  do
    TASK=$vtask
    echo "TASK $TASK"
    for vcontainer in $(ssh -o "StrictHostKeyChecking no" "$SWARM_ADM" docker inspect -f "{{.Status.ContainerStatus.ContainerID}}" "$TASK")
    do
      CONTAINER=$vcontainer
      echo "CONTAINER $CONTAINER"
     
      sgContainer=$(echo "$CONTAINER" | cut -c1-12)
      filelogContainer="${SERVICE_NAME}-${sgContainer}.log"
      echo "ssh ${HOST} docker logs ${CONTAINER}"
      ssh -o "StrictHostKeyChecking no" "$HOST" docker logs -f "$CONTAINER"
      
     
    done # CONTAINER
  done # TASK  
done # HOST


echo "[end]"


