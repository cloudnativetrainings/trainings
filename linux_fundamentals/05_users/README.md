# Users

In this lab you will learn how to manage users.

## Getting infos about Users

```bash
# get info about the user you are logged in
id

# see who is logged in into the machine (currently it is probably only you)
who

# see who logged in at which time
last

# getting basic info about users
cat /etc/passwd

# getting info about passwords, note they are one-way-hashed, so you cannot decrypt them
cat /etc/shadow

# info about groups
cat /etc/group
```

## Managing Users

```bash
# adding a new user with bash as shell and added to the group `users`
useradd -s /bin/bash -g users -u 9000 -m my-user

# verify a home directory was created
ls -alh /home/

# verify that the user is not a sudoer
cat /etc/group | grep sudo

# create password for user
passwd my-user

# verify that the user is in /etc/passwd 
cat /etc/passwd | grep my-user

# verify that the user is in /etc/shadow and the password is hashed 
cat /etc/shadow | grep my-user

# switch to my-user and go to its home directory
su my-user
cd

# try to update the package meta-info (which will not work due to permissions)
apt update

# try to update the package meta-info via upgrading to sudoer (which will not work due to my-user is not in the group of sudoers)
sudo apt update

# give the user my-user sudo permissions (note you have to exit to become root again for doing this)
exit
usermod -aG sudo my-user
cat /etc/group | grep sudo

# switch back to my-user, now the update command should work
su my-user
sudo apt update
exit

# delete the user
userdel my-user
cat /etc/passwd | grep my-user
cat /etc/shadow | grep my-user
cat /etc/group | grep sudo
```

# File Permissions

```bash
# add 2 users
useradd -s /bin/bash -g users -u 9001 -m my-user-a
useradd -s /bin/bash -g users -u 9002 -m my-user-b

# switch to my-user-a and create a file
su my-user-a
cd
echo "hello from user a" > my-file.txt
ls -alh

# change the file permission to RW only for user my-user-a
chmod 600 my-file
ls -alh
exit

# switch to my-user-b and try to read the file (note that my-user-b now has not the permission to read the file)
su my-user-b
cat /home/my-user-a/my-file.txt
exit
```
