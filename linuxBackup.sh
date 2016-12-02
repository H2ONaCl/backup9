#!/bin/bash

FLASHVOLUMELABEL=Flash
SOURCE=Documents
BACKUPS=Backups
FILENAMEROOT=Backup
LOGFILE=Backup.log

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

sudo chown -R "$USER":"$USER" "$MEDIAPATH"/"$FLASHVOLUMELABEL"

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

# execute on the desktop so that litter is obvious
pushd ~/Desktop
echo "pwd:"
pwd

if [ -d ~/"$BACKUPS" ]; then
    echo "Directory "$BACKUPS" exists so we will use it."
else
    echo "Directory "$BACKUPS" does not exist so we will create it."
    mkdir ~/"$BACKUPS"
fi

# remove old backup files by date, starting with the 2nd newest, remove the 2nd and any older
# use rm -f so that it will not complain if there are no files to be deleted
read -p "press the Enter key to delete some of the older *tgz files" key
ls -t ~/"$BACKUPS"/*tgz | gawk 'NR>=2' | xargs rm -f

# count the lines in the log file and store the result as a string
# then delete the log file
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

echo "end of tar operation. NOTE THAT tar REMOVED ALL LEADING FORWARD SLASHES TO MAKE RELATIVE PATHS."
echo ""
echo -e -n "\x07" # interpret escape sequence, no newline, console bell

echo "the tarball has been created."

echo "logging the tarball contents to the "$LOGFILE" file."

tar --list --verbose --preserve-permissions --gzip --file=/tmp/"$FILENAME" > ~/"$LOGFILE"

echo "previous log file line count "$PREVIOUSLINECOUNT""
NEWLINECOUNT=`wc --lines ~/"$LOGFILE"`
echo "new line count "$NEWLINECOUNT""

echo ""
echo "Moving the tarball from /tmp to "$BACKUPS"."
mv /tmp/"$FILENAME" ~/"$BACKUPS"

printf "syncing to the removable USB Flash drive.\n"
# here we clean up with the delete option.  
# NB: the --dirs means send not only files but also non-recursively the directories
# NB: use of delete option requires the use of --dirs
# NB: to use delete you omit the * from the source 
rsync --compress --dirs --delete \
--times --perms --owner --group \
--progress \
~/"$BACKUPS"/ "$MEDIAPATH"/"$FLASHVOLUMELABEL"

printf "the backup has been copied to the USB Flash drive.\n\n"

printf "performing a binary comparison to verify the new backup file on the USB Flash drive.\n\n"

cmp ~/"$BACKUPS"/"$FILENAME" "$MEDIAPATH"/"$FLASHVOLUMELABEL"/"$FILENAME"

printf "end of binary comparison.\n\n"

printf "end of backup script.\n"

printf "changing back to the original folder.\n"
popd
echo "pwd:"
pwd

exit 0
