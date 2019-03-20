# nfs_permission
A simple script that changes a user group and id to match a mounted nfs directory (useful on a pen test)


Requirements:
-Create a new user, or expect to use the last added user (as displayed in /etc/passwd)
-Find and mount an nfs share already (for best results, cd to that mount point)

Usage:
-input folder you which to access
-input local user you wish to modify
(script will change uid and gid to match within /etc/passwd)
(script will su to user)
-browse folder for juicy tidbits and data (bash history, ssh keys/known hosts, documents, firefox and chrome saved passwords)
