#!/bin/bash

SHOW_ALL=true

fn_print(){
    v_freet=$(ssh -o "StrictHostKeyChecking no" $HOST free -h | grep Mem: |  awk '{print $2}')
    v_freeu=$(ssh -o "StrictHostKeyChecking no" $HOST free -h | grep Mem: |  awk '{print $3}')
    v_freef=$(ssh -o "StrictHostKeyChecking no" $HOST free -h | grep Mem: |  awk '{print $4}')
    v_totaldisk=$(ssh -o "StrictHostKeyChecking no" $HOST df -l -h --total | grep total | sed "s/total                  /total disk/g")
    v_uptime=$(ssh -o "StrictHostKeyChecking no" $HOST uptime)
    v_total=$(ssh -o "StrictHostKeyChecking no" $HOST docker ps | wc -l )    #|  grep -c ""  
    v_uptime=$(echo "${v_uptime}" | sed "s/  0 users, //g")
    echo "${HOST} - ${v_total} container up - Mem T:${v_freet} U:${v_freeu} F:${v_freef} ${v_totaldisk}${v_uptime} "
}

#   CHOICE HOST
. "./components/choicehosts.sh"

echo "{HOST} - {v_total} container up - Mem T:{v_freet} U:{v_freeu} F:{v_freef} {v_totaldisk}{v_uptime} "
if [ "${HOST}" == "${V_ALL}" ]
then
    for HOST in $(ssh -o "StrictHostKeyChecking no" $SWARM_ADM  docker node ls --format "{{.Hostname}}")
    do
        fn_print
    done
else
    fn_print
fi