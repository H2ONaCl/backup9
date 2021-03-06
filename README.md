backup9
=======
A Linux backup for your data; not your system and settings and third-party applications.

WHY YOU MIGHT WANT TO USE THIS BACKUP APPLICATION:

* The backups are stored in a Flash drive removable storage device (or ideally a recycling set of such devices).
* It is transparent because it is a bash script that relies upon the venerable tools tar and rsync.
* It does not do incremental backups which might be inconvenient or opaque.
* It leaves a copy of the backup on the hard disk for convenience. 
* It can be easily modified to be invoked by cron. Just remove the pauses for a human response.
* It endeavours to backup only your data; not your system. 

This application is a bash script to create backups of a single directory tree, for example your ~/Documents. Restricting the backup to only your data, not your third-party application programs, economizes. 

If there is something within your system that you might consider to be "data" and you want to have it backed up, just put it in the same tree that contains the rest of your data.  For example, source code you authored should be in ~/Documents and bash scripts that you authored might be kept at ~/Documents/bashscripts instead of at /usr/bin

By default, the single directory tree is 

~/Documents

From that content the backup script will write a new timestamped backup to 

~/Backups

The timestamped backups will be "mirrored" or "synchronized" to the Flash drive. To mirror or sync means to copy to the destination and to delete from the destination what is not at the source.

This application also includes a bash script to backup a single directory tree of a guest operating system. For example, if linux is running VirtualBox and a Windows guest, then the guest can leave data at the single directory tree 

~/WindowsBackup   (Note: singular)

From that content the backup script will write a new timestamped backup to

~/WindowsBackups   (Note: plural)

The timestamped backups will be mirrored on the Flash drive.

How the guest system puts data at 

~/WindowsBackup (Note: singular) 

is a matter for you to decide. One suggestion is to configure VirtualBox to "see"
the linux drive and then use Windows' robocopy.exe.

THE ONE-TIME PREPARATION OF THE BACKUP MEDIUM IS TO FIRST LABEL THE FLASH DRIVE AS "Flash" FOR LINUX OR "WindowsFlash" FOR WINDOWS. SECONDLY GRANT OWNERSHIP TO userName OF THE DESTINATION DIRECTORY VIA ONE OF THE FOLLOWING COMMANDS.

sudo chown -R userName:userName /media/brian/Flash

sudo chown -R userName:userName /media/brian/WindowsFlash

TO INSTALL THIS BACKUP APPLICATION, FIRST MAKE IT EXECUTABLE:

chmod +x linuxBackup.sh

The equivalent for Windows is 

chmod +x windowsBackup.sh

TO INSTALL THE BACKUP APPLICATION JUST LEAVE IT ANYWHERE THAT CAN BE FOUND IN YOUR PATH ENVIRONMENT VARIABLE OR MODIFY THE ENVIRONMENT VARIABLE.

TO RUN THIS BACKUP APPLICATION, INSERT THE FLASH DRIVE, THEN RUN THE SCRIPT AS FOLLOWS:

./linuxBackup.sh

For backing-up Windows it is 

./windowsBackup.sh

The backup will be a .tgz file, which means that it is both a tar archive and that it has been gzipped.  tar is the original UNIX utility for making an archive. gzipping makes the file more compact.  Your newly created backup will have a file name that contains the date and time stamp.

A listing of the contents of the backup will be placed in 

~/Backup.log 

For backing-up Windows it is 

~/WindowsBackup.log

By default the 2 most recent backups are retained on ~/Backups or ~/WindowsBackups and the most recently used Flash drive will have the same files. If you need to keep older backups you can employ a set of Flash drives and recycle them.

AUXILIARY SCRIPTS ARE PROVIDED TO VERIFY THE ENTIRE REMOVABLE STORAGE DEVICE
Since the backup scripts already verify the most recent backup archive file, you may not likely find a need for these auxiliary scripts.

Example invocations:

./verifyLinuxBackup.sh 

./verifyWindowsBackup.sh 

AUXILIARY SCRIPTS ARE PROVIDED TO MIRROR THE BACKUPS TO THE REMOVABLE STORAGE DEVICE
These scripts do not create backup files. They merely take the files that were already created and "mirror" or "sync" them to the destination that is the removable storage device. To mirror or sync means to copy to the destination and to delete from the destination what is not at the source. Since the backup scripts already sync to the destination, you may not likely find a need for these auxiliary scripts.

Example invocations:

./linuxBackupPartial.sh

./windowsBackupPartial.sh
