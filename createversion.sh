#! /bin/bash

# config variables
PACKAGE="Plugin Flow Lookup"

echo ""
echo "Running `tput bold`sfdx package version create`tput sgr0` command..."
echo ""

startTime=`date +%s`

sfdx package version create \
 --package "$PACKAGE" \
 --skip-ancestor-check \
 --wait 30 \
 --code-coverage \
 --installation-key-bypass

endTime=`date +%s`
totalRuntime=$((endTime-startTime))
echo "`tput bold`Total runtime for command execution was $totalRuntime seconds.`tput sgr0`"

echo ""
echo "Don't forget to check if the release was successful and update the changelog.md"