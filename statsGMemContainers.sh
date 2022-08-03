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
##echo "CONTAINER_ID CONTAINER_NAME CPU MEMUSAGE \\ LIMIT MEMUSAGEPERC NETI \\ NETO BLOCKI \\ BLOCKO PIDS "
arrVar=""
for HOST in $(ssh -o "StrictHostKeyChecking no" $SWARM_ADM  docker node ls -f "role=worker" --format "{{.Hostname}}" )
do
  echo "${HOST}"
  IFS=$'\n'
  for MEM in $(ssh -o "StrictHostKeyChecking no" $HOST  docker stats --no-stream | grep -v PIDS )
  do
    
    CONTAINER_ID=$(echo $MEM | awk '{print $1}')
    CONTAINER_NAME=$(echo $MEM | awk '{print $2}')
    CPU=$(echo $MEM | awk '{print $3}')
    MEMUSAGE=$(echo $MEM | awk '{print $4}')
    BARRA=$(echo $MEM | awk '{print $5}')
    LIMIT=$(echo $MEM | awk '{print $6}')
    MEMUSAGEPERC=$(echo $MEM | awk '{print $7}')
    NETI=$(echo $MEM | awk '{print $8}')
    BARRA2=$(echo $MEM | awk '{print $9}')
    NETO=$(echo $MEM | awk '{print $10}')
    BLOCKI=$(echo $MEM | awk '{print $11}')
    BARRA3=$(echo $MEM | awk '{print $12}')
    BLOCKO=$(echo $MEM | awk '{print $13}')
    PIDS=$(echo $MEM | awk '{print $14}')

    # SUB='.'
    # if [[ ! "$MEMUSAGE" == *"$SUB"* ]]; then
    #     MEMUSAGE=${MEMUSAGE//MiB/.0MiB}
    #     MEMUSAGE=${MEMUSAGE//GiB/.0GiB}
    # fi
    SUB='MiB'
    i=1000
    if [[ ! "$MEMUSAGE" == *"$SUB"* ]]; then
        MEMUSAGE=${MEMUSAGE//MiB/}
        #MEMUSAGE=$(expr $MEMUSAGE*$i)
        MEMUSAGE=$(echo $MEMUSAGE $i | awk '{printf "%4.3f\n",$1*$2}')
    fi
    SUB='GiB'
    i=1000
    if [[ ! "$MEMUSAGE" == *"$SUB"* ]]; then
        MEMUSAGE=${MEMUSAGE//GiB/}
        #MEMUSAGE=$(expr $MEMUSAGE*$i)
        MEMUSAGE=$(echo $MEMUSAGE $i | awk '{printf "%4.3f\n",$1*$2}')
    fi

    MEMUSAGE=${MEMUSAGE//.000/}
    MEMUSAGE=$(printf %11s $MEMUSAGE)

    # echo "${string//,/$'\n'}"
    arrVar="${arrVar}${MEMUSAGE//iB/}\t${HOST}\t${CONTAINER_ID}\t${CONTAINER_NAME}\n"
    #echo "$CONTAINER_ID $CONTAINER_NAME $CPU $MEMUSAGE $BARRA $LIMIT $MEMUSAGEPERC $NETI $BARRA2 $NETO $BLOCKI $BARRA3 $BLOCKO $PIDS "
  done
done

arrVar="MEMUSAGE\tHOST\tCONTAINER_ID\tCONTAINER_NAME\n${arrVar}\nMEMUSAGE\tHOST\tCONTAINER_ID\tCONTAINER_NAME\n"
echo -e $arrVar | sort -h -k 1 