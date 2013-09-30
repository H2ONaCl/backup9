#!/bin/bash

clear
echo "backup script is starting..."
echo ""
echo "the backup can run from anywhere"
echo "the backup will pushd ~ and popd"
echo "the backup includes only ~/Documents"
echo ""
echo "usage:"
echo "    scriptname.sh             is used to invoke from a terminal"
echo "    scriptname.sh cron        is used to invoke an unattended run"
echo ""
echo "press the Enter key to continue."
read key

if [ -n "$1" ] && [ "$1" == "cron" ]; then
  cronflag="true"
else
  cronflag="false"
fi

if [ $cronflag == "true" ]; then 
  echo "changing to folder ~"
else
  read -p "press the Enter key to change folder to ~" key
fi

pushd ~
echo "pwd:"
pwd

if [ -f "backup.log" ]; then
  previouswc=`wc --lines backup.log`
else
  previouswc="0, no previous log file"
fi

if [ $cronflag == "true" ]; then
  echo "deleting any backup.log file."
else
  read -p "press the Enter key to delete the backup.log file from any previous run." key
fi

rm -f backup.log  # -f force no prompt and ignore missing

if [ $cronflag == "true" ]; then
  echo "making a date and time stamped tarball.  Here we go..."
else
  read -p "press the Enter key to make a date and time stamped tarball.  Here we go..." key
fi

DATETIME=`eval date +%Y%b%dT%H%M`
FILENAME="backup"$DATETIME".tgz"

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

tar --create --verbose --preserve-permissions --gzip --file=/tmp/$FILENAME \
Documents 

echo "end of tar operation."
echo ""
echo -e -n "\x07"

echo "the tarball has been created."

echo "logging the tarball contents to the backup.log file."

tar --list --verbose --preserve-permissions --gzip --file=/tmp/$FILENAME > backup.log

echo "previous log file line count $previouswc"
newwc=`wc --lines backup.log`
echo "new line count $newwc"

echo ""

# do not quote the RHS of the environment variable definition or else it will not expand
BACKUPS=~/backups

if [ -d "$BACKUPS" ]; then
    echo "Directory $BACKUPS exists so we will use it."
else
    echo "Directory $BACKUPS does not exist so we will create it."
    mkdir "$BACKUPS"
fi

echo ""
echo "Moving the tarball from /tmp to $BACKUPS."
mv /tmp/$FILENAME "$BACKUPS"

printf "syncing to the removable USB Flash device.\n"
# here we clean up with the delete option.  
# NB: the --dirs means send not only files but also non-recursively the directories
# NB: use of delete option requires the use of --dirs
# NB: to use delete you omit the * from the source 
rsync --compress --dirs --delete \
--times --perms --owner --group \
--progress \
"$BACKUPS"/ /media/usbFlash

printf "the backup has been copied to the USB Flash device.\n\n"

printf "performing a diff to verify the copy on the USB Flash device.\n\n"

diff "$BACKUPS"/$FILENAME /media/usbFlash/$FILENAME

printf "end of diff.\n\n"

printf "end of backup script.\n"

printf "changing back to the original folder.\n"
popd
echo "pwd:"
pwd

exit 0
