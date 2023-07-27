#!/bin/bash
hash=''
while getopts ":s:" opt; do
  case $opt in
  s)
    hash=$OPTARG
    ;;

  \?)
    echo "Invalid option: -$OPTARG" >&2
    ;;
  esac
done

echo "Hash value -> $hash"
authEmail=$(git log --format='%ae' $hash^!)
echo "Author value -> $authEmail"
while true; do
  if [[ "$authEmail" =~ ^[a-zA-Z0-9_.+-]+@(([a-zA-Z0-9-]+\.)?[a-zA-Z]+\.)?infobeans\.com$ ]]; then
    echo "InfoBeans Email detected $authEmail"
    commitMessage="$(git show-branch --no-name $hash)"
    echo "Commit message is -> $commitMessage"
    if [[ "$commitMessage" =~ ^SFDC-+ ]]; then
      echo "Commit message looks good $commitMessage"
      exit 0
    else
      exit 1
    fi
    break
  else
    parentSha=$(git rev-list --parents -n 1 $hash)
    echo "Parent sha are -> $parentSha"
    arrayParentSHA=($parentSha)
    hash=${arrayParentSHA[1]}
    echo "New hash value -> $hash"
    echo "Email address $authEmail is invalid."
    authEmail=$(git log --format='%ae' $hash^!)
    echo "New email value -> $authEmail"
  fi
done
