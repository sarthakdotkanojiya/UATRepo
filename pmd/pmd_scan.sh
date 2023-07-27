#!/bin/bash 

PMD_VERSION=6.41.0
PMD_SCAN_DIR=pmdSources/force-app/main/default
PMD_RULESET=pmd/ruleset.xml
PMD_RESULT_FOLDER=pmd/results/PMD_results.html
PMD_RESULT_FORMAT=summaryhtml

alias pmd="$HOME/pmd-bin-$PMD_VERSION/bin/run.sh pmd"
echo "Scanning $PMD_SCAN_DIR folder with $PMD_RULESET rules"
$HOME/pmd-bin-$PMD_VERSION/bin/run.sh pmd -d $PMD_SCAN_DIR -R $PMD_RULESET -f $PMD_RESULT_FORMAT -r $PMD_RESULT_FOLDER