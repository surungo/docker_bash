#!/bin/bash
SERVICE_NAME=$1
SWARM_ADM=$2
V_REGISTRY_UR1=
V_REGISTRY_UR2=

clear

. "../fun_get_constants.sh"

#CHOICE MANAGER
. "./components/choicecluster.sh"

echo -n "Filter search:  "
read filter
echo "filter ${filter}"

for HOST in $(ssh  "$SWARM_ADM" docker node ls --format "{{.Hostname}}" )
do
  echo "HOST $HOST"
  ssh -o "StrictHostKeyChecking no" "$HOST" docker images | grep "${filter}"
done

echo "[the end]"



