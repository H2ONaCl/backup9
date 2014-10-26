#!/bin/bash

FLASHVOLUMELABEL=WindowsFlash
SOURCE=WindowsBackup
BACKUPS=WindowsBackups
FILENAMEROOT=WindowsBackup
LOGFILE=WindowsBackup.log

clear
echo "backup script is starting..."
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

if [ -d /media/"$FLASHVOLUMELABEL" ]; then
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

# remove old files by date, starting with the 3rd newest, remove the 3rd and any older
# use rm -f so that it will not complain if there are no files to be deleted
read -p "press the Enter key to delete some of the older *tgz files" key
ls -t ~/"$BACKUPS"/*tgz | gawk 'NR>=3' | xargs rm -f

if [ -f ~/"$LOGFILE" ]; then
  PREVIOUSLINECOUNT=`wc --lines ~/"$LOGFILE"`
else
  PREVIOUSLINECOUNT="0, no previous log file"
fi

if [ $cronflag == "true" ]; then
  echo "deleting any "$LOGFILE" file."
else
  read -p "press the Enter key to delete the "$LOGFILE" file from any previous run." key
fi

rm -f ~/"$LOGFILE"  # -f force no prompt and ignore missing

if [ $cronflag == "true" ]; then
  echo "making a date and time stamped tarball.  Here we go..."
else
  read -p "press the Enter key to make a date and time stamped tarball.  Here we go..." key
fi

DATETIME=`eval date +%Y%b%dT%H%M`
FILENAME="$FILENAMEROOT"$DATETIME".tgz"

# note that tar . means tar this directory.  the dot is not a wildcard.
#
# note that tar * uses the shell to do the wildcard expansion.
#
# note that when extracting, the * wildcard will match what is present on
# the filesystem, not what is in the archive so you might fail to extract all 
# the files that you expected.
#
# note that there is a convention that ls does not show files that start with dot 
# and that convention is specific to ls and so it does not affect tar.

tar --create --verbose --preserve-permissions --gzip --file=/tmp/"$FILENAME" \
~/"$SOURCE"

echo "end of tar operation."
echo ""
echo -e -n "\x07" # interpret escape, no newline

echo "the tarball has been created."

echo "logging the tarball contents to the "$LOGFILE" file."

tar --list --verbose --preserve-permissions --gzip --file=/tmp/"$FILENAME" > ~/"$LOGFILE"

echo "previous log file line count "$PREVIOUSLINECOUNT""
NEWLINECOUNT=`wc --lines ~/"$LOGFILE"`
echo "new line count "$NEWLINECOUNT""

echo ""

if [ -d ~/"$BACKUPS" ]; then
    echo "Directory "$BACKUPS" exists so we will use it."
else
    echo "Directory "$BACKUPS" does not exist so we will create it."
    mkdir ~/"$BACKUPS"
fi

echo ""
echo "Moving the tarball from /tmp to "$BACKUPS"."
mv /tmp/"$FILENAME" ~/"$BACKUPS"

printf "syncing to the removable USB Flash device.\n"
# here we clean up with the delete option.  
# NB: the --dirs means send not only files but also non-recursively the directories
# NB: use of delete option requires the use of --dirs
# NB: to use delete you omit the * from the source 
rsync --compress --dirs --delete \
--times --perms --owner --group \
--progress \
~/"$BACKUPS"/ /media/"$FLASHVOLUMELABEL"

printf "the backup has been copied to the USB Flash device.\n\n"

printf "performing a diff to verify the copy on the USB Flash device.\n\n"

diff ~/"$BACKUPS"/"$FILENAME" /media/"$FLASHVOLUMELABEL"/"$FILENAME"

printf "end of diff.\n\n"

printf "end of backup script.\n"

printf "changing back to the original folder.\n"
popd
echo "pwd:"
pwd

exit 0
