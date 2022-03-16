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

for i in ${!V_SWARM_ADM_ARRAY[@]}; do
  echo "    Choice $i is ${V_SWARM_ADM_ARRAY[$i]}"
done
echo ""
echo " Choice a number:"	
echo -n "Number:  "
read OPTION_NUMBER
SWARM_ADM="${V_SWARM_ADM_ARRAY[$OPTION_NUMBER]}"
echo "SWARM_ADM: $SWARM_ADM"

		
