#! /bin/bash

PACKAGE="Plugin Flow Lookup"

echo ""
echo "Running `tput bold`sfdx package create`tput sgr0` command..."
echo ""

startTime=`date +%s`

sfdx package create \
 --name "$PACKAGE" \
 --package-type Unlocked \
 --description "Open-source Plugin to get access to the list of active flows in your org from the lightning context." \
 --path force-app

endTime=`date +%s`
totalRuntime=$((endTime-startTime))
echo "`tput bold`Total runtime for command execution was $totalRuntime seconds.`tput sgr0`"
