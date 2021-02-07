#!/bin/bash

kubectl delete -n dynatrace oneagent --all

kubectl delete -f https://github.com/Dynatrace/dynatrace-oneagent-operator/releases/latest/download/kubernetes.yaml
kubectl delete -k https://github.com/Dynatrace/dynatrace-operator/config/manifests

kubectl delete namespace dynatrace
