#!/bin/bash

#LOAD CONSTANTS
if [ -z "$V_ENV" ] 
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

for i in ${!V_ENV[@]}; do
  echo "    Choice $i is ${V_ENV[$i]}"
done
echo ""
echo " Choice a number:"	
echo -n "Number:  "
read OPTION_NUMBER
ENV="${V_ENV[$OPTION_NUMBER]}"

if [ "${ENV}" == "${V_CANCEL}" ]
then
    echo "Process canceled"
    exit
fi
echo "ENV: $ENV"

		
