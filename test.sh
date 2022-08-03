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
#!/bin/bash


./components/choicecluster.sh


echo "V_REGISTRY_BASE: ${V_REGISTRY_BASE}"
echo "V_REGISTRY_UR1: ${V_REGISTRY_UR1}"
echo "V_REGISTRY_UR2: ${V_REGISTRY_UR2}"
echo "V_CANCEL: ${V_CANCEL}"
echo "V_ALL: ${V_ALL}"
echo "SHOW_ALL: ${SHOW_ALL}"
echo "V_SWARM_ADM_ARRAY: ${V_SWARM_ADM_ARRAY}"
echo "V_ENV: ${V_ENV}"
echo "V_FILTER_GREP_ENV: ${V_FILTER_GREP_ENV}"



echo "${V_ENV[*]}"
echo "sed 's/__dsv-/__/g'| sed 's/__tst-/__/g'  | sed 's/__hmg-/__/g' | sed 's/__esp-/__/g' | sed 's/__prod-/__/g'"
echo "sed 's/__${V_ENV[1]}/__/g'| sed 's/__${V_ENV[2]}/__/g'  | sed 's/__${V_ENV[3]}/__/g' | sed 's/__${V_ENV[4]}/__/g' | sed 's/__${V_ENV[5]}/__/g'"