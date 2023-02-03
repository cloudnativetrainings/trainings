
## system logs
```bash
# getting last logs
journalctl -f -u falco 
```

## logs of component
```sh
journalctl -u etcd.service -l
```

## fix certs issues
if api-server does not work log files via `docker logs ...`


## base64


## getting config
```bash
ps aux | grep kubelet
cat /var/lib/kubelet/config.yaml

cat /lib/systemd/system/kubelet.service 
```

# Linux Users 

```bash
# get info about user
id

# who is logged in
who

# who logged in at which time
last

# basic info about users, no password
/etc/passwd

# passwords
/etc/shadow

# info about groups
/etc/group

# dissallow login for user
usermod -s /bin/nologin michael
grep -i michael /etc/passwd

# adding a user
sudo useradd -s /bin/bash -g developers -G docker,ops -u 2328 -m -d /home/somepath hubert
sudo adduser jim

# change password for user
sudo passwd david

# del user
userdel bob
grep -i bob /etc/passwd

# add user to group
usermod rob -G admin

# del user from group
id michael
deluser michael admin
id michael

# del group
groupdel devs
```

# finding out service using port
```bash
netstat -tulpen | grep 8088
systemctl list-units  -t service --state active | grep -i openlitespeed
systemctl stop lshttpd
systemctl disable lshttpd
apt list --installed | grep openlitespeed
apt remove openlitespeed -y
```

# Ports

```bash

# list ports
netstat -an | grep -w LISTEN

# find which service is using which port
cat /etc/services | grep -w 53

```

# SSH

```bash
# change ssh settings
vi /etc/ssh/sshd_config
systemctl restart sshd

# disable root account
PermitRootLogin no

# disable passwords
PasswordAuththenitcation no

# pass private key into ssh command
ssh -i

# copy public key to destination server
ssh-copy-id -i ~/.ssh/id_rsa.pub jim@node01
```

# Privilege Escalation

```bash
cat /etc/sudoers
visudo

# make user a sudoer
visudo
jim ALL=(ALL:ALL) ALL

# allow user to run sudo commands without passwd
visudo
jim ALL=(ALL) NOPASSWD:ALL

# make the members of a group to sudoers (note the %)
%admin ALL=(ALL) ALL
```

# Packages

```bash

# see all installed packages
apt list --installed

```

## Services

```bash

# List all services
systemctl list-units --type service

systemctl stop my-service

```


# Firewalls

```bash

# install ufw
apt update
apt install ufw
systemctl enable ufw

# reset firewall
ufw reset

# list rules
ufw status numbered

# create rules
ufw default allow outgoing
ufw default deny incoming

# allow ssh access
ufw allow 22 

# allow TCP port 22 from ip to any interface
ufw allow from 172.16.238.5 to any port 22 proto tcp

# allow TCP port 80 from ip to any interface
ufw allow from 172.16.238.5 to any port 80 proto tcp

# allow TCP port 80 ufw from ip-range to any interface
ufw allow from 172.16.100.0/28 to any port 80 proto tcp

# allow port range
ufw allow 1000:2000/tcp

# be sure that you are not locked out before starting the fw
systemctl start ufw

ufw status

# deleting a rule
ufw deny 8080
ufw delete deny 8080

# delete via line number
ufw delete 5

# reseting the firewall
ufw reset

# temp disable ufw
ufw disable
ufw enable
```

# syscalls

```bash
strace touch /tmp/error.log

# trace existing programm
pidof etcd
strace -p <PID>

# tab output
strace -c touch /tmp/error.log
```


