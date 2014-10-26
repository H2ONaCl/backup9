#!/bin/bash
# You can run this from anywhere.
# The one and only argument is the name of the medium at /media/...
# The purpose of this script is to compare the hard disk to the removeable medium.

BACKUPDIRECTORY=WindowsBackups

diffMethod() {
  echo "start of diffs..."
  # option -r is recursive
  diff -r ~/"$BACKUPDIRECTORY" /media/"$1"
  echo " "
  echo "END of diffs."
}

pushd ~/Desktop

echo "The Volume Label is:"
echo "$1" 
echo "Press any key to continue or Ctrl-C to abort."
read key

if [ ! -d /media/"$1" ]
then
  printf "\nThe media was not found.\n"
else
  diffMethod "$1"
fi

popd

exit 0

