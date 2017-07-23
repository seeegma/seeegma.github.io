#!/bin/bash
oldname=$1
newname="$(echo $oldname | tr '[:upper:]' '[:lower:]' | sed 's/link-to-//' )"
echo $oldname
echo $newname
cd ..
ag "$oldname"
