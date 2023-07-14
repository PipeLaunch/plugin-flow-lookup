#! /bin/bash
# Promote package version

# config variables
PACKAGE_ALIAS_VERSION="Plugin Flow Lookup@1.2.0-1"
DEVHUB_ALIAS="pipelaunch"

startTime=`date +%s`

read -e -i "$PACKAGE_ALIAS_VERSION" -p "Package alias version: " packagealiasinput # requires bash 4.0 or later
DEVHUB_APACKAGE_ALIAS_VERSIONLIAS=${packagealiasinput:-$PACKAGE_ALIAS_VERSION}

echo "Running `tput bold`sfdx package version promote`tput sgr0` command..."

sfdx package version promote \
    --package "$PACKAGE_ALIAS_VERSION" \
    --target-dev-hub $DEVHUB_ALIAS

endTime=`date +%s`
totalRuntime=$((endTime-startTime))
echo "`tput bold`Total runtime for script execution was $totalRuntime seconds.`tput sgr0`"