#!/bin/bash
SWARM_ADM=$1
V_REGISTRY_UR1=
V_REGISTRY_UR2=

. "../fun_get_constants.sh"

#CHOICE MANAGER
. "./components/choicecluster.sh"

#   CHOICE HOST
HOSTS=($(ssh -o "StrictHostKeyChecking no" $SWARM_ADM  docker node ls --format "{{.Hostname}}"))
for i in ${!HOSTS[@]}; do
  echo "    Choice $i is ${HOSTS[$i]}"
done
echo ""
echo " Choice a number of manager:"	
echo -n "Number:  "
read OPTION_HOSTS_NUMBER
HOST="${HOSTS[$OPTION_HOSTS_NUMBER]}"
echo "SWARM_ADM: $HOST"

ssh "$HOST" docker images


echo "[the end]"



