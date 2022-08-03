#!/bin/bash

SHOW_ALL=true

fn_print(){
    echo "ssh -o \"StrictHostKeyChecking no\" ${HOST} docker ps | grep \"$V_REGISTRY_BASE\" | awk \'{print \$1}\' "
    for CONTAINER_ID in $(ssh -o "StrictHostKeyChecking no" ${HOST} docker ps | grep "$V_REGISTRY_BASE" | awk '{print $1}')
    do
        ##echo "ssh -o \"StrictHostKeyChecking no\" ${HOST} docker container inspect -f \"{{.Name}} {{.NetworkSettings.Networks}}\" ${CONTAINER_ID}"
        CONTAINER_NAME=$(ssh -o "StrictHostKeyChecking no" ${HOST} docker container inspect -f "{{.Name}}" ${CONTAINER_ID})
        NetworkSettings_Networks=$(ssh -o "StrictHostKeyChecking no" ${HOST} docker container inspect -f "{{.NetworkSettings.Networks}}" ${CONTAINER_ID})
        
        #NetworkSetting_Network=""
        #for NetworkSettings_Networks in  $(ssh -o "StrictHostKeyChecking no" ${HOST} docker container inspect -f "{{.NetworkSettings.Networks}}" ${CONTAINER_ID})
        #do
        #    NetworkSettings_Networks=$( echo "${NetworkSettings_Networks}" | tr -d '\n' )
        #    NetworkSetting_Network="${NetworkSetting_Network} ${NetworkSettings_Networks}"
        #done
        

        #NetworkSettings_Networks=${NetworkSettings_Networks//$'\n'/}
        #NetworkSettings_Networks=${NetworkSettings_Networks%$'\n'}
        #NetworkSettings_Networks=${NetworkSettings_Networks//$'\r'/}
        #NetworkSettings_Networks=${NetworkSettings_Networks%$'\r'}
        #NetworkSettings_Networks=$( echo "${NetworkSettings_Networks}" | tr -d '\r' )
        #NetworkSettings_Networks=$( echo "${NetworkSettings_Networks}" | tr -d '\n' )
        echo "$CONTAINER_NAME"
        for element in ${NetworkSettings_Networks[@]}
        do
        echo "    $element"
        done
    done

}

#   CHOICE HOST
. "./components/choicehosts.sh"

if [ "${HOST}" == "${V_ALL}" ]
then
    for HOST in $(ssh -o "StrictHostKeyChecking no" $SWARM_ADM  docker node ls --format "{{.Hostname}}")
    do
        fn_print
    done
else
    fn_print
fi



