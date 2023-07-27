#!/bin/bash

package=''
TestClasses=''
SF_BUSINESS_USER_QA=''
timeOut=''
checkOnlyParam=''
deploymentResult=deployResult/result.txt
mkdir "deployResult"
while getopts ":x:c:r:u:w:" opt; do
  case $opt in
    x)
      package=$OPTARG
      ;;
    c)
      checkOnlyParam=$OPTARG
      ;;
    r)
      TestClasses=$OPTARG
      ;;
    u)
      SF_BUSINESS_USER_QA=$OPTARG
      ;;
    w)
      timeOut=$OPTARG
      ;;

    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

countApexClass=$(grep -c "<name>ApexClass</name>" $package)
echo '1 -> '$countApexClass
echo '2 -> '$SF_BUSINESS_USER_QA
echo '3 -> '$timeOut
echo '4 -> '$TestClasses
echo '5 -> '$checkOnlyParam
echo '6 -> '$deploymentResult

#Decide whether to run test run or not
if [[ $countApexClass -gt 0 ]]
then
  if [[ $checkOnlyParam == "--prodDeploy" || $checkOnlyParam == "--uatDeploy" || $checkOnlyParam == "--qaDeploy" ]]
  then
    echo "deploy is set"
    checkOnlyParam="";
  else
    echo "Proddeploy is not set"
    checkOnlyParam="--checkonly";
  fi
  echo "Test Classess to be run"
  sfdx force:source:deploy -x $package $checkOnlyParam  -l 'RunSpecifiedTests'  -r $TestClasses -u $SF_BUSINESS_USER_QA -w $timeOut --verbose
else
  if [[ $checkOnlyParam == "--prodDeploy" ]]
  then
    echo "Prod Test Classess to be run"
    sfdx force:source:deploy -x $package -l 'RunLocalTests' -u $SF_BUSINESS_USER_QA -w $timeOut --verbose
  else
    if [[ $checkOnlyParam == "--uatDeploy" || $checkOnlyParam == "--qaDeploy" ]]
    then
      echo "deploy is set to UAT or QA with no test class Run"
      checkOnlyParam="";
    fi
    echo "No Test Class to be run"
    sfdx force:source:deploy -x $package $checkOnlyParam  -l 'NoTestRun' -u $SF_BUSINESS_USER_QA -w $timeOut --verbose
  fi
fi