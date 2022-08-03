#!/bin/bash
SWARM_ADM=$1
V_REGISTRY_UR1=
V_REGISTRY_UR2=

. "../fun_get_constants.sh"

#CHOICE MANAGER
. "./components/choicecluster.sh"

#   CHOICE HOST
. "./components/choicehosts.sh"

#CHOICE ENV
. "./components/choiceenv.sh"

echo "prune containers host $HOST "
ssh -o "StrictHostKeyChecking no" $HOST docker container prune -f
for CONTAINER_ID in $(ssh "$HOST" docker ps | grep ${ENV} | awk '{print $1}')
do
  LABELS=$(ssh -o "StrictHostKeyChecking no" $HOST docker inspect -f "{{.Config.Labels}}" $CONTAINER_ID)
  LABELS=${LABELS#map*service.name:}
  SERVICE_NAME=${LABELS% com.docker.swarm.task:*]}

  echo "ssh -o \"StrictHostKeyChecking no\" $SWARM_ADM docker service scale ${SERVICE_NAME}=0"
  ssh -o "StrictHostKeyChecking no" $SWARM_ADM docker service scale ${SERVICE_NAME}=0

  echo "ssh -o \"StrictHostKeyChecking no\" $SWARM_ADM docker service update ${SERVICE_NAME}"
  ssh -o "StrictHostKeyChecking no" $SWARM_ADM docker service update ${SERVICE_NAME}
  
  echo "ssh -o \"StrictHostKeyChecking no\" $SWARM_ADM docker service scale ${SERVICE_NAME}=1"
  ssh -o "StrictHostKeyChecking no" $SWARM_ADM docker service scale ${SERVICE_NAME}=1

done

echo "[the end]"



