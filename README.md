backup9
=======

A linux backup script for your data; not your system and settings.

WHY YOU MIGHT WANT TO USE THIS BACKUP APPLICATION:

* It is very simple.
* It is transparent because it is a bash script.
* It relies upon the venerable tools tar and rsync.
* It does not do incremental backups which might be inconvenient or opaque.
* It leaves a copy of the backup on the hard disk for convenience. 
* It can be invoked by cron.
* It endeavours to backup only your data; not your system. 

This application is a bash script to create backups of a single directory tree, for example your ~/Documents. The backup medium is a Flash drive. Restricting the backup to only your data, not your programs, economizes. 

If there is something within your "system" that you might consider to be "data" and you want to have it backed up, just put it under the same tree that contains the rest of your data.  For example, bash scripts that you authored might be kept at ~/Documents/bashscripts instead of at /usr/bin

By default, the single directory tree is 

~/Documents

From that content the backup script will write a new timestamped backup to 

~/Backups

The timestamped backups will be mirrored on the Flash drive.

This application also includes a bash script to backup a single directory tree of a guest operating system. For example, if linux is running VirtualBox and a Windows guest, then the guest can leave data at the single directory tree 

~/WindowsBackup   (Note: singular)

From that content the backup script will write a new timestamped backup to

~/WindowsBackups   (Note: plural)

The timestamped backups will be mirrored on the Flash drive.

How the guest system puts data at 

~/WindowsBackup (Note: singular) 

is a matter for you to decide. One suggestion is to configure VirtualBox to "see"
the linux drive and then use Windows' robocopy.exe.

THE ONE-TIME PREPARATION OF THE BACKUP MEDIUM IS TO LABEL THE FLASH DRIVE AS 
"Flash" FOR LINUX OR "WindowsFlash" FOR WINDOWS. 

TO INSTALL THIS BACKUP APPLICATION, FIRST MAKE IT EXECUTABLE:

chmod +x linuxBackup.sh

The equivalent for Windows is 

chmod +x windowsBackup.sh

TO INSTALL THE BACKUP APPLICATION JUST LEAVE IT ANYWHERE THAT CAN BE FOUND IN YOUR PATH ENVIRONMENT VARIABLE OR MODIFY THE ENVIRONMENT VARIABLE.

TO RUN THIS BACKUP APPLICATION, INSERT THE FLASH DRIVE, THEN RUN THE SCRIPT AS FOLLOWS:

./linuxBackup.sh

The equivalent for Windows is 

./windowsBackup.sh

The backup will be a .tgz file, which means that it is both a tar archive and that it has been gzipped.  tar is the original UNIX utility for making an archive. gzipping makes the file more compact.  Your newly created backup will have a file name that contains the date and time stamp.

A listing of the contents of the backup will be placed in 

~/Backup.log 

The equivalent for Windows is 

~/WindowsBackup.log

By default the 2 most recent backups are retained on ~/Backups or ~/WindowsBackups and the most recently used Flash drive will have the same files. If you need to keep much older backups you can employ a set of Flash drives and recycle them.

SCRIPTS ARE PROVIDED TO VERIFY THE ENTIRE FLASH DISK

Example invocations:

./verifyLinuxBackup.sh 

./verifyWindowsBackup.sh 

