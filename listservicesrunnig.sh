#!/bin/bash
SWARM_ADM=$1
V_REGISTRY_UR1=
V_REGISTRY_UR2=

. "../fun_get_constants.sh"

if [ -z "$SWARM_ADM" ] 
then
    echo " "
    echo " "
	  echo " ./listservicesrunning.sh manager.domain.com "
    
    echo " "
    echo " "
    exit
fi


for i in $(ssh  "$SWARM_ADM" docker service ls -q )
do
  SERVICE_NAME=$i
  ssh "$SWARM_ADM" docker service ps ${SERVICE_NAME} | grep Running
done

echo "[the end]"



