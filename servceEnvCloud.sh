#!/bin/bash

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

echo "ssh -o \"StrictHostKeyChecking no\" \"$SWARM_ADM\"  docker service ls | grep $V_REGISTRY_BASE | awk '{print \$2}' "
for SERVICE_NAME in $(ssh -o "StrictHostKeyChecking no" "$SWARM_ADM"  docker service ls | grep "$V_REGISTRY_BASE" | awk '{print $2}' )
do
  #echo "ssh -o \"StrictHostKeyChecking no\" \"$SWARM_ADM\" docker service inspect -f \"{{.Spec.TaskTemplate.ContainerSpec.Env}}\" \"$SERVICE_NAME\""
  ENV=$(ssh -o "StrictHostKeyChecking no" "$SWARM_ADM" docker service inspect -f "{{.Spec.TaskTemplate.ContainerSpec.Env}}" "$SERVICE_NAME")
  #if [[ ${ENV} != *"SPRING_CLOUD_CONFIG_LABEL"* ]];then
  if [[ ${ENV} != *"optional:configserver"* ]];then
  
    echo "$SERVICE_NAME $ENV"
  fi
  
  
done

echo "[the end]"



