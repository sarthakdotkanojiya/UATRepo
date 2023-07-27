#!/bin/bash

classsvalue=`cat package/package.xml | xq . | jq '.Package.types | if type=="array" then .[] else . end | select(.name=="ApexClass")|select(.members!="Test")|.members | if type == "string" then [.] else . end | join(",")'`
classsvalue=`sed -e 's/^"//' -e 's/"$//' <<<$classsvalue`
IFS=', ' read -r -a array <<< $classsvalue
for element in "${array[@]}"
do
    #echo "$element"
   if echo "$element" | grep 'Test'; then
      #echo "It's there!"
      arr=($element "${arr[@]}")
   fi
done
printf -v joined '%s,' "${arr[@]}"
#echo "${joined%,}"
echo "${joined%,}"  >> TestClassess
cat TestClassess
