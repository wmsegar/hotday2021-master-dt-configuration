#!/bin/bash

export API_TOKEN=$(cat ../1-Credentials/creds.json | jq -r '.dynatraceApiToken')
export PAAS_TOKEN=$(cat ../1-Credentials/creds.json | jq -r '.dynatracePaaSToken')
export TENANTID=$(cat ../1-Credentials/creds.json | jq -r '.dynatraceTenantID')
export HOST_GROUP=$(cat ../1-Credentials/creds.json | jq -r '.dynatraceHostGroup')
export NETWORK_ZONE=$(cat ../1-Credentials/creds.json | jq -r '.dynatraceNetworkZone')
export HOST_GROUP_PARAM="--set-host-group="$HOST_GROUP

kubectl create namespace dynatrace

kubectl apply -f https://github.com/Dynatrace/dynatrace-oneagent-operator/releases/latest/download/kubernetes.yaml

kubectl -n dynatrace create secret generic oneagent --from-literal="apiToken="$API_TOKEN --from-literal="paasToken="$PAAS_TOKEN

if [[ -f "cr.yaml" ]]; then
    rm -f cr.yaml
    echo "Removed cr.yaml"
fi

if [[-f "mycr.yaml" ]]; then
    rm -f mycr.yaml
    echo "Removed mycr.yaml"
fi

curl -o cr.yaml https://raw.githubusercontent.com/Dynatrace/dynatrace-oneagent-operator/master/deploy/cr.yaml

sed -i 's/apiUrl: https:\/\/ENVIRONMENTID.live.dynatrace.com\/api/apiUrl: https:\/\/'$TENANTID'.sprint.dynatracelabs.com\/api/' cr.yaml
yq eval ".spec.args[1] = \"$HOST_GROUP_PARAM\"" cr.yaml > mycr.yaml

kubectl create -f mycr.yaml
