#!/bin/bash

#   CHOICE HOST
. "./components/choicehosts.sh"

echo "ssh -o \"StrictHostKeyChecking no\" $HOST docker container prune -f"
ssh -o "StrictHostKeyChecking no" $HOST docker container prune -f

echo "[the end]"



