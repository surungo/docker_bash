#!/bin/bash
SERVICE_NAME=$1
FOLDER=$2
SWARM_ADM=$3

TASK=
HOST=
CONTAINER=

V_REGISTRY_UR1=
V_REGISTRY_UR2=

. "../fun_get_constants.sh"

if [ -z "$SERVICE_NAME" ] || [ -z "$FOLDER" ] 
then
    echo " "
    echo " "
    echo " ./execinservicescontainer.sh tst-service 'ls -la /'"
    echo " ./execinservicescontainer.sh tst-service 'ls -la logs'"
    echo " ./execinservicescontainer.sh tst-service 'java -version'"
    echo " ./execinservicescontainer.sh tst-service 'java -cp lib/catalina.jar org.apache.catalina.util.ServerInfo'"
    echo " ./execinservicescontainer.sh tst-service 'uname -r'"
    echo " ./execinservicescontainer.sh tst-service 'ps -aux'"
    echo " ./execinservicescontainer.sh hmg-service 'ls -la /etc/ssl/certs'"
    echo " ./execinservicescontainer.sh hmg-service 'ls -la /etc/pki/ca-trust/extracted/pem'"
    echo " ./execinservicescontainer.sh esp-service 'find ./ -name service.war'"
    echo " ./execinservicescontainer.sh esp-service 'find . -print | grep ojdbc'"
    echo " ./execinservicescontainer.sh esp-service 'find . -print | grep log4j'"
    echo " ./execinservicescontainer.sh esp-service 'ls -la webapps/service/WEB-INF/lib' "
    
    echo " "
    echo " "
    exit
fi

if [ -z "$SWARM_ADM" ] 
then
#get manager
. "../fun_get_manager.sh"
fi

for TASK in $(ssh -o "StrictHostKeyChecking no" $SWARM_ADM  docker service ps $SERVICE_NAME | grep Running | awk '{print $1}')
do
  echo TASK $TASK
  HOST=$(ssh -o "StrictHostKeyChecking no" $SWARM_ADM  docker service ps $SERVICE_NAME | grep Running | grep $TASK | awk '{print $4}')
  echo HOST $HOST
  for CONTAINER in $(ssh -o "StrictHostKeyChecking no" $SWARM_ADM  docker inspect -f "{{.Status.ContainerStatus.ContainerID}}" $TASK)
  do
    echo CONTAINER $CONTAINER
    #echo "$HOST docker exec $CONTAINER $FOLDER"
    ssh -o "StrictHostKeyChecking no" $HOST docker exec $CONTAINER $FOLDER
  done
done
echo " "
echo " "
echo " "


