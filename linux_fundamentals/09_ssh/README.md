# Connecting to other machines via SSH

In this lab you will learn how to switch to other machines.

# Create a new key pair

```bash
# try to connect to the other vm, which will not work out due to you haven't shared your public key yet
ssh training-lf-ssh

# create your key pair (you can leave all inputs blank)
ssh-keygen

# verify that the key pair has been created properly
ls -alh ~/.ssh
```

# Copy the public key to the destination machine

Open a new tab in the Google Cloud Shell editor

```bash
# connect to the detination machine
gcloud compute ssh root@training-lf-ssh --zone europe-west3-a

# open the authorized_keys file via via
vi ~/.ssh/authorized_keys

# copy and paste the content of the file ~/.ssh/id_rsa.pub of the source machine into the file ~/.ssh/authorized_keys of the destination machine

# afterwards you can close this Google Cloud Shell editor tab again
```

# Connect from the source machine to the destination machine

```bash
# connect to the destination machine (note the machine name: root@training-lf-ssh)
ssh root@training-lf-ssh

# switch back to the source machine (note the machine name: root@training-lf)
exit
```

# SSH Config File

You can create a ssh config file which comes in handy. Create the file on the source machine in the location `~/.ssh/config`

Add the following content to the file
```config
Host destination
    HostName training-lf-ssh
    User root
```

```bash
# connect to the destination machine (note the machine name: root@training-lf-ssh)
ssh destination

# switch back to the source machine (note the machine name: root@training-lf)
exit
```

# Copying files to other machines

```bash
# create a file
echo "shared" > shared.txt

# copy the file to the destination machine into its home folder (in our case /root/)
scp shared.txt destination:
```

# Execute a command on another machine

```bash
# you can trigger commands via ssh on the destination machine like this
ssh destination "hostname && ls -alh && cat ~/shared.txt"
```
