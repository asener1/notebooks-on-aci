#!/bin/bash

RG=$1
CGN=$2
CN=$3

TOKEN=$(az container logs --resource-group $RG --name $CGN --container-name $CN | grep token= | head -1 | cut -d "=" -f2)
IP=$(az container show --resource-group $RG --name $CGN | grep -w ip | cut -d ":" -f2 | cut -d "," -f1 | tr -d \" | sed -e 's/^[[:space:]]*//')

echo "Below is the link for your jupyter session"
echo http://$IP:8888/?token=$TOKEN