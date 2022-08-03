#!/bin/bash

echo ""
echo ""
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


echo "ssh -o \"StrictHostKeyChecking no\" $SWARM_ADM docker service ls | grep \" 0/1 \" "
IFS=$'\n'
for SERVICE_ARR in $(ssh -o "StrictHostKeyChecking no" $SWARM_ADM docker service ls | grep " 0/1 " )
do
    SERVICE_NAME=$(echo $SERVICE_ARR | awk '{print $2}')
    IMAGE_FULL=$(echo $SERVICE_ARR | awk '{print $5}')
    REPO=$(echo $IMAGE_FULL | cut -d "/" -f 1)
    IMAGE_NAME=$(echo $IMAGE_FULL | cut -d "/" -f 2 | cut -d ":" -f 1)
    IMAGE_VERSION=$(echo $IMAGE_FULL | cut -d "/" -f 2 | cut -d ":" -f 2)
    echo " "
    echo ${IMAGE_FULL}
    # #echo ${REPO}
    # #echo ${IMAGE_NAME}
    # #echo ${IMAGE_VERSION}


    echo ""
    echo "image"
    for HOST in $(ssh -o "StrictHostKeyChecking no" $SWARM_ADM  docker node ls -f "role=worker" --format "{{.Hostname}}")
    do
        echo "ssh -o \StrictHostKeyChecking no\ $HOST  docker images | grep \"${REPO}/${IMAGE_NAME}\" | grep ${IMAGE_VERSION}"
        IMAGE_HOST=$(ssh -o "StrictHostKeyChecking no" $HOST  docker images | grep "${REPO}/${IMAGE_NAME}" | grep ${IMAGE_VERSION})
        if [ ! -z "${IMAGE_HOST}" ]
        then
            IMAGE_ID=$(echo ${IMAGE_HOST} | awk '{print $3}')
            echo ${IMAGE_ID} 
            echo "ssh \"StrictHostKeyChecking no\" ${HOST} docker tag ${IMAGE_ID} ${IMAGE_FULL}"
            ssh -o "StrictHostKeyChecking no" "${HOST}" docker tag "${IMAGE_ID}" "${IMAGE_FULL}"
            echo "ssh \"StrictHostKeyChecking no\" ${HOST} docker push ${IMAGE_FULL}"
            ssh -o "StrictHostKeyChecking no" "${HOST}" docker push "${IMAGE_FULL}"

            #up in host
            echo "ssh \"StrictHostKeyChecking no\" $SWARM_ADM docker service scale $SERVICE_NAME=0"
            ssh -o "StrictHostKeyChecking no" $SWARM_ADM docker service scale $SERVICE_NAME=0
            
            echo "ssh \"StrictHostKeyChecking no\" $SWARM_ADM docker service update --constraint-add node.hostname==$HOST $SERVICE_NAME"
            ssh -o "StrictHostKeyChecking no" $SWARM_ADM docker service update --constraint-add node.hostname!=$HOST $SERVICE_NAME

            echo "ssh \"StrictHostKeyChecking no\" $SWARM_ADM docker service scale $SERVICE_NAME=1"
            ssh -o "StrictHostKeyChecking no" $SWARM_ADM docker service scale $SERVICE_NAME=1
            
            echo "sleep 3"
            sleep 3
            echo "ssh \"StrictHostKeyChecking no\" $SWARM_ADM docker service update --constraint-rm node.hostname==$HOST $SERVICE_NAME"
            ssh -o "StrictHostKeyChecking no" $SWARM_ADM docker service update --constraint-rm node.hostname!=$HOST $SERVICE_NAME

            
            echo " "
            RUNNER=$(ssh -o "StrictHostKeyChecking no" "$SWARM_ADM" docker service ps -f "desired-state=Running" "$SERVICE_NAME")
            if [ ! -z "$RUNNER" ]
            then
                break
            fi

        fi
    done

    if [ -z "$RUNNER" ]
    then
        echo ""
        echo "ps"
        for HOST in $(ssh -o "StrictHostKeyChecking no" $SWARM_ADM  docker node ls -f "role=worker" --format "{{.Hostname}}")
        do
            #echo "host ${HOST}"
            echo "ssh -o \"StrictHostKeyChecking no\" $HOST  docker ps | grep ${IMAGE_FULL}"
            CONTAINER_HOST=$(ssh -o "StrictHostKeyChecking no" $HOST  docker ps | grep ${IMAGE_FULL})
            
            # echo "ssh -o \"StrictHostKeyChecking no\" $HOST  docker ps | grep ${IMAGE_NAME}"
            # CONTAINER_HOST=$(ssh -o "StrictHostKeyChecking no" $HOST  docker ps | grep ${IMAGE_NAME})
            
            if [ ! -z "${CONTAINER_HOST}" ]
            then
                
                IMAGE_OLD=$(echo $CONTAINER_HOST | awk '{print $2}')
                CONTAINER_ID=$(echo $CONTAINER_HOST | awk '{print $1}')
                echo "container ${CONTAINER_ID} oldimage ${IMAGE_OLD}"
                if [ ! -z "${IMAGE_OLD}" ]
                then
                    echo "ssh -o \"StrictHostKeyChecking no\" $HOST docker commit ${CONTAINER_ID} "
                    COMMIT=$( ssh -o "StrictHostKeyChecking no" $HOST docker commit ${CONTAINER_ID} )
                    echo ${COMMIT}
                    IMAGE_ID_OLD=$(echo ${COMMIT} | cut -d ":" -f 2)

                    echo "ssh \"StrictHostKeyChecking no\" ${HOST} docker tag ${IMAGE_ID_OLD} ${IMAGE_FULL}"
                    ssh -o "StrictHostKeyChecking no" "${HOST}" docker tag "${IMAGE_ID_OLD}" "${IMAGE_FULL}"
                    echo "ssh \"StrictHostKeyChecking no\" ${HOST} docker push ${IMAGE_FULL}"
                    ssh -o "StrictHostKeyChecking no" "${HOST}" docker push "${IMAGE_FULL}"

                    #up in host
                    echo "ssh \"StrictHostKeyChecking no\" $SWARM_ADM docker service scale $SERVICE_NAME=0"
                    ssh -o "StrictHostKeyChecking no" $SWARM_ADM docker service scale $SERVICE_NAME=0
            
                    echo "ssh \"StrictHostKeyChecking no\" $SWARM_ADM docker service update --constraint-add node.hostname==$HOST $SERVICE_NAME"
                    ssh -o "StrictHostKeyChecking no" $SWARM_ADM docker service update --constraint-add node.hostname!=$HOST $SERVICE_NAME
                    
                    
                    echo "ssh \"StrictHostKeyChecking no\" $SWARM_ADM docker service scale $SERVICE_NAME=1"
                    ssh -o "StrictHostKeyChecking no" $SWARM_ADM docker service scale $SERVICE_NAME=1
            
                    echo "sleep 3"
                    sleep 3
                    echo "ssh \"StrictHostKeyChecking no\" $SWARM_ADM docker service update --constraint-rm node.hostname==$HOST $SERVICE_NAME"
                    ssh -o "StrictHostKeyChecking no" $SWARM_ADM docker service update --constraint-rm node.hostname!=$HOST $SERVICE_NAME
                    echo " "
                    RUNNER2=$(ssh -o "StrictHostKeyChecking no" "$SWARM_ADM" docker service ps -f "desired-state=Running" "$SERVICE_NAME")
                    if [ ! -z "$RUNNER2" ]
                    then
                        break
                    fi
                    
                fi
            fi
        done
    fi
  
done
		
