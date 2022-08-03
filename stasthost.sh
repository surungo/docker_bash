#!/bin/bash
SWARM_ADM=$1
V_REGISTRY_UR1=
V_REGISTRY_UR2=


#CHOICE HOST
. "./components/choicehosts.sh"

ssh -o "StrictHostKeyChecking no" "$HOST" docker stats


echo "[the end]"

 

