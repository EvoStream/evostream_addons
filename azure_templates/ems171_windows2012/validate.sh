#!/bin/sh
TEMPLATE="azuredeploy.json"
GROUP="albany"
DNSPREFIX="ems171dns"
azure group template validate -f $TEMPLATE -g $GROUP -p "{\"storageAccountNamePrefix\":{\"value\":\"ems171sa\"}, \"adminUsername\":{\"value\":\"user\"}, \"adminPassword\":{\"value\":\"pass\"}, \"dnsLabelPrefix\":{\"value\":\"$DNSPREFIX\"}}"
