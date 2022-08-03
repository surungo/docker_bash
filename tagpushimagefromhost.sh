#!/bin/bash

#LOAD CONSTANTS
if [ -z "$V_SWARM_ADM_ARRAY" ] 
then

    FILE=../../fun_get_constants.sh
    if [[ -f "$FILE" ]]; then
        . "${FILE}"
    fi

    FILE=../fun_get_constants.sh
    if [[ -f "$FILE" ]]; then
        . "${FILE}"
    fi

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

echo "filter ${filter}"

#for i in $(ssh  $SWARM_ADM  docker node ls | awk '{print $2}' | grep pucrs )
for i in $(ssh -o "StrictHostKeyChecking no" "$SWARM_ADM" docker node ls -f "role=worker" --format "{{.Hostname}}" )
do
  HOST=$i
  echo ""
  echo "$HOST"
  
  #echo ${V_REGISTRY_UR1}
  #echo ${V_REGISTRY_UR2}

  INFOARRAY=$(ssh -o "StrictHostKeyChecking no" "$HOST" docker images --format "${HOST}#__{{.Repository}}__#{{.ID}}#{{.CreatedAt}}#{{.Size}}#{{.Repository}}:{{.Tag}}" | sed "s/__${V_REGISTRY_UR1}[[:punct:]]//g" | sed "s/__${V_REGISTRY_UR2}[[:punct:]]/__/g"   | sed 's/__${V_ENV[1]}/__/g'| sed 's/__${V_ENV[2]}/__/g'  | sed 's/__${V_ENV[3]}/__/g' | sed 's/__${V_ENV[4]}/__/g' | sed 's/__${V_ENV[5]}/__/g'  | grep "__${filter}__" )
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

echo "[the end]"


