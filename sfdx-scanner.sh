#! /bin/bash

startTime=`date +%s`

# open file with default app
openfile() {
    if [ -f "$1" ]; then
        if [ "$(uname)" == "Darwin" ] || [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
            open $1
        elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ] || [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
            start $1
        fi
    fi
}

# delete the previous scan results
rm -rf ./sfdx-scanner-results/scanner-classes.html
rm -rf ./sfdx-scanner-results/scanner-classes-security.html

# Updating and copying submodules into package feature folders
dt=$(date '+%d/%m/%Y %H:%M:%S');
echo "$dt - Security Scanner"

# Apex classes
echo "Running code scanner Apex Classes..."
sfdx scanner:run --target "./**/classes/**" \
    --format "html" \
    --outfile ./sfdx-scanner-results/scanner-classes.html
openfile ./sfdx-scanner-results/scanner-classes.html

# total execution time statistics
endTime=`date +%s`
totalRuntime=$((endTime-startTime))
echo "`tput bold`Total runtime for script execution was $totalRuntime seconds.`tput sgr0`"
