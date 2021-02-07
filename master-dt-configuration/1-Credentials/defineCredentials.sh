#!/bin/bash

YLW='\033[1;33m'
NC='\033[0m'

CREDS=./creds.json
rm $CREDS 2> /dev/null

echo -e "${YLW}Please enter the credentials as requested below: ${NC}"
read -p "Dynatrace Tenant ID (ex. https://<TENANT_ID>.sprint.dynatracelabs.com: " DTTEN
read -p "Dynatrace API Token: " DTAPI
read -p "Dynatrace PaaS Token: " DTPAAS
read -p "Dynatrace Host Group: " DTHOSTGROUP
read -p "Dynatrace Network Zone: " DTNETWORKZONE
echo ""

echo ""
echo -e "${YLW}Please confirm all are correct: ${NC}"
echo "Dynatrace Tenant ID: $DTTEN"
echo "Dynatrace API Token: $DTAPI"
echo "Dynatrace PaaS Token: $DTPAAS"
echo "Dynatrace Host Group: $DTHOSTGROUP"
echo "Dynatrace Network Zone: $DTNETWORKZONE"
read -p "Is this all correct? (y/n) : " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]
then
    rm $CREDS 2> /dev/null
    cat ./creds.sav | sed 's~DYNATRACE_TENANT_ID~'"$DTTEN"'~' | \
      sed 's~DYNATRACE_API_TOKEN~'"$DTAPI"'~' | \
      sed 's~DYNATRACE_HOST_GROUP~'"$DTHOSTGROUP"'~' | \
      sed 's~DYNATRACE_NETWORK_ZONE~'"$DTNETWORKZONE"'~' | \
      sed 's~DYNATRACE_PAAS_TOKEN~'"$DTPAAS"'~' >> $CREDS
fi

cat $CREDS
echo ""
echo "The credentials file can be found here:" $CREDS
echo ""
