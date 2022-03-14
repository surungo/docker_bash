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

#myArray=()

for i in $(ssh  "$SWARM_ADM" docker service ls -q )
do
  SERVICE_NAME=$i
  ##echo "SWARM_ADM: $SWARM_ADM"

    for TASK in $(ssh -o "StrictHostKeyChecking no" $SWARM_ADM  docker service ps $SERVICE_NAME | grep Running | awk '{print $1}')
    do
    ##echo TASK $TASK
    HOST=$(ssh -o "StrictHostKeyChecking no" $SWARM_ADM  docker service ps $SERVICE_NAME | grep Running | grep $TASK | awk '{print $4}')
    ##echo HOST $HOST
    for CONTAINER in $(ssh -o "StrictHostKeyChecking no" $SWARM_ADM  docker inspect -f "{{.Status.ContainerStatus.ContainerID}}" $TASK)
    do
        ##echo CONTAINER $CONTAINER
        TIME=$(ssh -o "StrictHostKeyChecking no" $HOST  docker inspect -f "{{.State.StartedAt}}" $CONTAINER)
        TIME=$(echo ${TIME} | cut -c 1-10 | sed 's/-//g' )
        if [ -z "${myArray[${TIME}]}" ]
        then
            myArray[${TIME}]=1
        else
            myArray[${TIME}]=$((${myArray[${TIME}]} + 1))
        fi
        echo "${TIME}: ${myArray[${TIME}]} "
    done
  done  
done

for i in ${!myArray[@]}; do
  echo "Container born in $i are a total of ${myArray[$i]}"
done

echo "[the end]"



