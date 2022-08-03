#!/bin/bash


V_REGISTRY_UR1=
V_REGISTRY_UR2=
V_REGISTRY=
filter=

function listnone(){
    echo " ssh -o \"StrictHostKeyChecking no\" \"$HOST\" docker images | grep \"$V_REGISTRY\" | grep \"<none>\" "
    ssh -o "StrictHostKeyChecking no" "$HOST" docker images | grep "$V_REGISTRY" | grep "<none>"
}

function tagpush()
{
    echo "---tagpush---"
    echo "IMAGE_ID $IMAGE_ID"
    echo "IMAGE_FULL $IMAGE_FULL"
    echo "ssh -o \"StrictHostKeyChecking no\" \"$HOST\" docker tag \"$IMAGE_ID\" \"$IMAGE_FULL\" "
    ssh -o "StrictHostKeyChecking no" "$HOST" docker tag "$IMAGE_ID" "$IMAGE_FULL" 
    echo "ssh -o \"StrictHostKeyChecking no\" \"$HOST\" docker push \"$IMAGE_FULL\" "
    ssh -o "StrictHostKeyChecking no" "$HOST" docker push "$IMAGE_FULL"
}
function tagpushbusca()
{
    echo "---tagpushbusca---"
    echo "V_REGISTRY $V_REGISTRY"
    echo " ssh -o \"StrictHostKeyChecking no\" \"$HOST\" docker images | grep \"$V_REGISTRY\" | grep \"<none>\" | awk '{print $3}' "
    IFS=$'\n'
    for IMAGE_ID in $(ssh -o "StrictHostKeyChecking no" "$HOST" docker images | grep "$V_REGISTRY" | grep "<none>" | awk '{print $3}' )
    do
        echo "IMAGE_ID $IMAGE_ID"
        echo " ssh -o \"StrictHostKeyChecking no\" \"$HOST\" docker images | grep \"$IMAGE_ID\" | awk '{print $1}' "
        IMAGE_NAME_HOST=$(ssh -o "StrictHostKeyChecking no" "$HOST" docker images | grep "$IMAGE_ID" | awk '{print $1}')
        echo "IMAGE_NAME_HOST $IMAGE_NAME_HOST"
        echo " ssh -o \"StrictHostKeyChecking no\" \"$HOST\" docker ps | grep \"$IMAGE_NAME_HOST\" | awk '{print $2}' "
        IMAGE_FULL=$(ssh -o "StrictHostKeyChecking no" "$HOST" docker ps | grep "$IMAGE_NAME_HOST" | awk '{print $2}')
       
        
        if [[ ! -z "$IMAGE_FULL" ]]
        then

            tagpush "$@"
        fi

        if [[ -z "$IMAGE_FULL" ]]
        then
            echo "---tagpushbusca2---"
            IMAGE_NAME=$(echo "$IMAGE_NAME_HOST" | cut -f2 -d'/')
            echo "IMAGE_NAME $IMAGE_NAME"
            echo " ssh -o \"StrictHostKeyChecking no\" \"$HOST\" docker ps | grep \"$IMAGE_NAME\" |grep \"$IMAGE_ID\" | awk '{print $1}' "
            for CONTAINER_ID in $(ssh -o "StrictHostKeyChecking no" "$HOST" docker ps | grep "$IMAGE_NAME" | grep "$IMAGE_ID" | awk '{print $1}' )
            do
                echo "  ssh -o \"StrictHostKeyChecking no\" \"$HOST\" docker container inspect $CONTAINER_ID -f {{.Name}} "
                CONTAINER_NAME=$(ssh -o "StrictHostKeyChecking no" "$HOST" docker container inspect "$CONTAINER_ID" -f {{.Name}})
                echo "CONTAINER_NAME: $CONTAINER_NAME"
                TASK_ID=$(echo "$CONTAINER_NAME" | cut -f3 -d'.')
                TASK_ID12=$(echo "$TASK_ID" | cut -c 1-12)
                echo "TASK_ID12: $TASK_ID12"
                LABELS=$(ssh -o "StrictHostKeyChecking no" $HOST docker inspect -f "{{.Config.Labels}}" $CONTAINER_ID)
                LABELS=${LABELS#map*service.name:}
                SERVICE_NAME=${LABELS% com.docker.swarm.task:*]}
                echo "SERVICE_NAME: $SERVICE_NAME"
                IMAGE_FULL=$(ssh -o "StrictHostKeyChecking no" "$SWARM_ADM" docker service ps "$SERVICE_NAME" | grep $TASK_ID12 | awk '{print $3}')
                tagpush "$@"
            done
        fi        

        
    done

    
}

#   CHOICE HOST
. "./components/choicehosts.sh"

# echo -n "Filter search:  "
# read filter
# echo "filter ${filter}"

V_REGISTRY="$V_REGISTRY_UR1"
tagpushbusca "$@"
V_REGISTRY="$V_REGISTRY_UR2"
tagpushbusca "$@"

V_REGISTRY="$V_REGISTRY_UR1"
listnone "$@"
V_REGISTRY="$V_REGISTRY_UR2"
listnone "$@"




echo "[the end]"


#    IMAGE_FULL=$(ssh -o "StrictHostKeyChecking no" "$HOST" docker inspect -f "{{.Config.Image}}" $CONTAINER_ID)
#    IMAGE_ID=$(ssh -o "StrictHostKeyChecking no" "$HOST" docker image inspect -f "{{.Id}}" "$IMAGE_FULL")
#    IMAGE_FULL=$(echo $IMAGE_FULL | cut -f1 -d'@')
#    if [[ "$IMAGE_FULL" == *"pucrs.br"* ]]; then
#        #echo $CONTAINER_ID
#         #echo $IMAGE_FULL
#         #echo $IMAGE_ID 
#        echo ssh -o "StrictHostKeyChecking no" "$HOST" docker tag $IMAGE_ID "$IMAGE_FULL"
#        echo ssh -o "StrictHostKeyChecking no" "$HOST" docker push "$IMAGE_FULL"
#     fi
#echo "ssh -o \"StrictHostKeyChecking no\" $HOST docker container prune -f"
#ssh -o "StrictHostKeyChecking no" $HOST docker container prune -f


