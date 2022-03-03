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
	  echo " ./findimagemincluster.sh esp-avaliacaoDisciplinas "
    
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

#for i in $(ssh  $SWARM_ADM  docker node ls | awk '{print $2}' | grep pucrs )
for i in $(ssh -o "StrictHostKeyChecking no" "$SWARM_ADM" docker node ls --format "{{.Hostname}}" )
do
  HOST=$i
  echo ""
  #echo "$HOST"
  
  #echo ${V_REGISTRY_UR1}
  #echo ${V_REGISTRY_UR2}

  #  INFOARRAY=$(ssh "$HOST" docker images --format "${HOST}#__{{.Repository}}__#{{.ID}}#{{.CreatedAt}}#{{.Size}}#{{.Repository}}:{{.Tag}}" | sed 's/__build.pucrs.br:5000[[:punct:]]//g'| sed 's/__gitlab.pucrs.br:5443[[:punct:]]/__/g' | sed 's/ /./g' | sed 's/__dsv-/__/g'| sed 's/__tst-/__/g'  | sed 's/__hmg-/__/g' | sed 's/__esp-/__/g' | sed 's/__prod-/__/g' | grep "__${filter}__" )
  INFOARRAY=$(ssh -o "StrictHostKeyChecking no" "$HOST" docker images --format "${HOST}#__{{.Repository}}__#{{.ID}}#{{.CreatedAt}}#{{.Size}}#{{.Repository}}:{{.Tag}}" | sed "s/__${V_REGISTRY_UR1}[[:punct:]]//g" | sed "s/__${V_REGISTRY_UR2}[[:punct:]]/__/g" | sed 's/ /./g' | sed 's/__dsv-/__/g'| sed 's/__tst-/__/g'  | sed 's/__hmg-/__/g' | sed 's/__esp-/__/g' | sed 's/__prod-/__/g' | grep "__${filter}__" )
  if [ -z "$INFOARRAY" ] 
  then
    echo "image not found in ${HOST}"
    echo ""
  else
    echo "${INFOARRAY}" | sed "s/__${filter}__#//g" | sed 's/__//g' | sed 's/#/\t/g'
    echo " tag and push all images in ${HOST}"	
    echo -n "[ y or n ] Yes or No:  "
    read OPTIONYN
  fi
  if [ "y" = "$OPTIONYN" ]
  then
    for INFO in ${INFOARRAY}
    do
        #echo "${INFO}"
        INFOLINE=$(echo "${INFO}" | sed "s/__${filter}__#//g" | sed 's/__//g' | sed 's/#/\t/g' )
        #echo "${INFOLINE}"
        IMAGEID=$(echo "${INFOLINE}" | awk '{print $2}')
        #echo "IMAGEID: ${IMAGEID}"
        IMAGENAME=$(echo "${INFOLINE}" | awk '{print $5}')
        #echo "IMAGENAME: ${IMAGENAME}"
        echo "ssh ${HOST} docker tag ${IMAGEID} ${IMAGENAME}"
        ssh -o "StrictHostKeyChecking no" "${HOST}" docker tag "${IMAGEID}" "${IMAGENAME}"
        echo "ssh ${HOST} docker push ${IMAGENAME}"
        ssh -o "StrictHostKeyChecking no" "${HOST}" docker push "${IMAGENAME}"
        
    done
  fi
  
done

echo "[fim]"


