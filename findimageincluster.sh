#!/bin/bash
SERVICE_NAME=$1
SWARM_ADM=$2
V_REGISTRY_UR1=
V_REGISTRY_UR2=

. "../fun_get_constants.sh"

if [ -z "$SERVICE_NAME" ] 
then
    echo " "
    echo " "
	  echo " ./findimagemincluster.sh esp-address "
    
    echo " "
    echo " "
    exit
fi

filter=$(echo $SERVICE_NAME | sed 's/^dsv-//g')
filter=$(echo $filter | sed 's/^tst-//g')
filter=$(echo $filter | sed 's/^hmg-//g')
filter=$(echo $filter | sed 's/^esp-//g')
filter=$(echo $filter | sed 's/^prod-//g')

if [ -z "$SWARM_ADM" ] 
then
#get manager
. "../fun_get_manager.sh"
fi

echo "filter ${filter}"

for i in $(ssh  "$SWARM_ADM" docker node ls --format "{{.Hostname}}" )
do
  HOST=$i
  ssh "$HOST" docker images --format "${HOST}#__{{.Repository}}__#{{.ID}}#{{.CreatedAt}}#{{.Size}}#{{.Repository}}:{{.Tag}}" | sed 's/__${V_REGISTRY_UR1}[[:punct:]]//g'| sed 's/__${V_REGISTRY_UR2}[[:punct:]]/__/g' | sed 's/__dsv-/__/g'| sed 's/__tst-/__/g'  | sed 's/__hmg-/__/g' | sed 's/__esp-/__/g' | sed 's/__prod-/__/g' | grep "__${filter}__" | sed "s/__${filter}__#//g" | sed 's/__//g' | sed 's/#/\t/g'
done

echo "[the end]"



