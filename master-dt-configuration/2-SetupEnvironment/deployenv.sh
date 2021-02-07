#!/bin/bash


export API_TOKEN=$(cat ../1-Credentials/creds.json | jq -r '.dynatraceApiToken')
export PAAS_TOKEN=$(cat ../1-Credentials/creds.json | jq -r '.dynatracePaaSToken')
export TENANTID=$(cat ../1-Credentials/creds.json | jq -r '.dynatraceTenantID')
export HOST_GROUP=$(cat ../1-Credentials/creds.json | jq -r '.dynatraceHostGroup')
export NETWORK_ZONE=$(cat ../1-Credentials/creds.json | jq -r '.dynatraceNetworkZone')

echo "Deploying Dynatrace with the following options "
echo "API_TOKEN = $API_TOKEN"
echo "PAAS_TOKEN = $PAAS_TOKEN"
echo "TENANTID = $TENANTID"
echo "HOST GROUP = $HOST_GROUP"
echo "Network Zone = $NETWORK_ZONE"

echo ""
read -p "Is this all correct? (y/n) : " -n 1 -r
echo ""

echo "Deploying OneAgent Operator"

../utils/installer.sh --api-url https://"${TENANTID}".sprint.dynatracelabs.com/api "--api-token "${API_TOKEN}"" "--paas-token "${PAAS_TOKEN}"" "--enable-volume-storage" "--enable-k8s-monitoring"  "--set-host-group "${HOST_GROUP}""

echo "Waiting for OneAgent to startup"
sleep 120

echo "Deploying SockShop Application"
../utils/deploy-sockshop.sh
echo -e "${YLW}Waiting about 5 minutes for all pods to become ready...${NC}"
sleep 330s
