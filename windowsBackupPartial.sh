#!/bin/bash

FLASHVOLUMELABEL=WindowsFlash
BACKUPS=WindowsBackups

clear
echo "backup script is starting..."
echo ""
echo "export MEDIAPATH before invoking this script"
echo "example: export MEDIAPATH=/media/UserName"
echo ""
echo "the backup can run from anywhere"
echo "the backup will pushd ~/ and popd"
echo ""
echo "usage:"
echo "    scriptname.sh             is used to invoke from a terminal"
echo "    scriptname.sh cron        is used to invoke an unattended run"
echo ""
echo "press the Enter key to continue."
read key

if [ -d "$MEDIAPATH"/"$FLASHVOLUMELABEL" ]; then
  echo "destination detected"
else
  echo "destination not detected"
  exit 1
fi

if [ -n "$1" ] && [ "$1" == "cron" ]; then
  cronflag="true"
else
  cronflag="false"
fi

if [ $cronflag == "true" ]; then 
  echo "changing to folder ~/Desktop"
else
  read -p "press the Enter key to change folder to ~/Desktop" key
fi

pushd ~/Desktop
echo "pwd:"
pwd

printf "syncing to the removable USB Flash drive.\n"
# here we clean up with the delete option.  
# NB: the --dirs means send not only files but also non-recursively the directories
# NB: use of delete option requires the use of --dirs
# NB: to use delete you omit the * from the source 
rsync --compress --dirs --delete \
--times --perms --owner --group \
--progress \
~/"$BACKUPS"/ "$MEDIAPATH"/"$FLASHVOLUMELABEL"

printf "end of backup script.\n"

printf "changing back to the original folder.\n"
popd
echo "pwd:"
pwd

exit 0
