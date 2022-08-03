#!/bin/bash

echo "./loadHostDocker.sh"
echo " Choice a number 0 to cancel:"	
echo " Choice a number 1 to proced"	
echo -n "Number:  "
read OPTION_CANCEL_NUMBER
if [ "${OPTION_CANCEL_NUMBER}" == "${V_CANCEL}" ]
then
    echo "Process canceled"
    exit
fi
./loadHostDocker.sh
echo "SWARM_ADM: $SWARM_ADM"



echo "./tagAllNoneHost.sh"
echo " Choice a number 0 to cancel:"	
echo " Choice a number 1 to proced"	
echo -n "Number:  "
read OPTION_CANCEL_NUMBER
if [ "${OPTION_CANCEL_NUMBER}" == "${V_CANCEL}" ]
then
    echo "Process canceled"
    exit
fi
./tagAllNoneHost.sh

echo "./containerprune-f.sh"
echo " Choice a number 0 to cancel:"	
echo " Choice a number 1 to proced"	
echo -n "Number:  "
read OPTION_CANCEL_NUMBER
if [ "${OPTION_CANCEL_NUMBER}" == "${V_CANCEL}" ]
then
    echo "Process canceled"
    exit
fi
./containerprune-f.sh

echo "./imageprune-a.sh"
echo " Choice a number 0 to cancel:"	
echo " Choice a number 1 to proced"	
echo -n "Number:  "
read OPTION_CANCEL_NUMBER
if [ "${OPTION_CANCEL_NUMBER}" == "${V_CANCEL}" ]
then
    echo "Process canceled"
    exit
fi
./imageprune-a.sh


echo "./loadHostDocker.sh"
echo " Choice a number 0 to cancel:"	
echo " Choice a number 1 to proced"	
echo -n "Number:  "
read OPTION_CANCEL_NUMBER
if [ "${OPTION_CANCEL_NUMBER}" == "${V_CANCEL}" ]
then
    echo "Process canceled"
    exit
fi
./loadHostDocker.sh


echo "[the end]"


