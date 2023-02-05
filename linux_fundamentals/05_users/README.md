```bash
# get info about user
id

# who is logged in
who

# who logged in at which time
last

# basic info about users, no password
# TODO slides https://www.cyberciti.biz/faq/understanding-etcpasswd-file-format/
cat /etc/passwd

# passwords
cat /etc/shadow

# info about groups
# TODO slides what are groups
cat /etc/group

# dissallow login for user
usermod -s /bin/nologin michael
grep -i michael /etc/passwd

# adding a user
useradd -s /bin/bash -g users -u 1234 -m my-user
=> check home directory
sudo adduser jim

# TODO check etc/groups before adding my-user to sudo

# change password for user
passwd david
=> cat /etc/passwd

su my-user
cd

apt update
=> does not work due to permissions

sudo apt update
=> does not work due to my-user is no sudoer

exit
usermod -aG sudo my-user
cat /etc/group | grep sudo
su my-user
sudo apt update






# del user from group
id michael
deluser michael admin
id michael

# del user
userdel my-user
cat /etc/passwd | grep my-user

# del group
groupdel devs
```

# file permissions
```bash
useradd -s /bin/bash -g users -u 9000 -m my-user-a
useradd -s /bin/bash -g users -u 9001 -m my-user-b

su my-user-a
cd
touch my-file
ls -alh
chmod 600 my-file
ls -alh
exit
su my-user-b
cat /home/my-user-a/my-file
=> permission denied

exit
cat /home/my-user-a/my-file
=> works, but no content

# TODO slides https://askubuntu.com/questions/83/how-do-file-permissions-work