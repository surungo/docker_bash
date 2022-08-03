#!/bin/bash

#   CHOICE HOST
. "./components/choicehosts.sh"

echo "ssh -o \"StrictHostKeyChecking no\" $HOST docker image prune -a -f"
ssh -o "StrictHostKeyChecking no" $HOST docker image prune -a -f

echo "[the end]"



