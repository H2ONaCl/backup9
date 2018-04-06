#!/bin/bash
# You can run this from anywhere.
# The context will be ~/Desktop
# Set and export MEDIAPATH="/media/UserName" before running this script.
# The purpose of this script is to compare the hard disk to the removeable medium.
#
# This script uses diff instead of cmp because diff has recursion.

BACKUPDIRECTORY=Backups
VOLUMELABEL=Flash
VOLUMEPATH="$MEDIAPATH"/"$VOLUMELABEL"

diffMethod() {
  echo "start of diffs..."
  diff --recursive --brief ~/"$BACKUPDIRECTORY" "$VOLUMEPATH"
  echo " "
  echo "END of diffs."
}

pushd ~/Desktop

echo "The Volume Label is:"
echo "$VOLUMELABEL" 
echo "Press any key to continue or Ctrl-C to abort."
read key

if [ -d "$VOLUMEPATH" ]; then
  echo "destination detected"
else
  echo "destination not detected"
  exit 1
fi

diffMethod 

popd

exit 0

