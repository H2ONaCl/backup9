WHY YOU MIGHT WANT TO USE THIS BACKUP APPLICATION:

1. It is very simple.
2. It is transparent because it is a bash script.
3. It uses trusted tools such as tar and rsync.
4. It does not do incremental backups which might be inconvenient or opaque.
5. It leaves a copy of the backup on the hard disk for convenience.  
6. It can be invoked by cron.
7. It endeavours to backup only your data; not your system. 

This application is a bash script to create backups of user documents or a single directory tree.
The backup medium is a Flash Drive. It endeavours to backup only a single tree from your
linux system, presumeably your data; not your operating system files. Restricting the 
backup to only your data economizes.  

If there is something within your "system" that you might consider to be "data" and 
you want to have it backed up, just put it under the same tree that contains the 
rest of your data.  For example, bash scripts that you authored might be kept at 
/home/yourName/Documents/bashscripts instead of at /usr/bin

By default, the single directory tree is 
/home/yourName/Documents
From that content the backup script will write a new timestamped backup to 
/home/yourName/Backups
One or more timestamped backups at
/home/yourName/Backups will be duplicated on the Flash Drive at /media/Flash

There is a bash script to backup user documents or a single directory tree of a guest 
operating system. For example, if linux is running VirtualBox and a Windows guest,
then the guest can leave data at the single directory tree 
/home/yourName/WindowsBackup   (Note: singular)
From that content the backup script will write a new timestamped backup to
/home/yourName/WindowsBackups   (Note: plural)
One or more timestamped backups at
/home/yourName/WindowsBackups will be duplicated on the Flash Drive at /media/WindowsFlash

How the guest leaves data at /home/yourName/WindowsBackup (Note: singular) is a matter
not covered by this backup script. One suggestion is to configure VirtualBox to "see"
the linux drive and then use Windows' robocopy.exe.

THE ONE-TIME PREPARATION OF THE BACKUP MEDIUM IS TO LABEL THE FLASH DRIVE AS 
"Flash" FOR LINUX OR "WindowsFlash" FOR WINDOWS.

TO INSTALL THIS BACKUP APPLICATION, FIRST MAKE IT EXECUTABLE:

chmod +x linuxBackup.sh
The equivalent for Windows is 
chmod +x windowsBackup.sh

TO INSTALL THE BACKUP APPLICATION JUST LEAVE IT ANYWHERE THAT CAN BE FOUND IN YOUR PATH.

TO RUN THIS BACKUP APPLICATION, INSERT THE FLASH DRIVE, THEN RUN THE SCRIPT AS FOLLOWS:

./linuxBackup.sh
The equivalent for Windows is 
./windowsBackup.sh

The backup will be a .tgz file, which means that it is both a tar archive and that it has
been gzipped.  tar is the original UNIX utility for archives.  gzipping makes the file
more compact.  Your newly created backup will have a file name that contains the
date and time stamp.  

A listing of the contents of the backup will be placed in /home/yourName/Backup.log 

The equivalent for Windows is /home/yourName/WindowsBackup.log

The default capacity is 3 backups. Edit the script if your Flash Drive has a higher capacity.
For example, if your .tgz files are approximately 4GB each and you have a 16GB Flash Drive, it 
appears that the default 3 backups can be changed to 4, although it may be imprudent to 
approach the limit of capacity.

SCRIPTS ARE PROVIDED TO VERIFY THE ENTIRE FLASH DISK
Example invocations:
verifyLinuxBackup.sh Flash
verifyWindowsBackup.sh WindowsFlash

The script relies upon a Flash Drive because it is fast but if you want more permanent backups
you can copy all your backup files to an optical disk. The verification scripts can also
be used to verify an optical disk. Suppose the optical disk has the label "myDiskLabel", then
the disk will appear at
/media/myDiskLabel
Example invocations:
verifyLinuxBackup.sh myDiskLabel
verifyWindowsBackup.sh myDiskLabel

