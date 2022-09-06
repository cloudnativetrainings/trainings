# Encryption of Etcd Backups

## The Problem

```bash 
# create a backup
etcdctl snapshot save backup.db

# verify the 2nd secret
cat backup.db | grep -a password456

# verify the 1st secret - note that the secret is still in plain text due to etcd still holds the old revisions of the secret
cat backup.db | grep -a password123
```


## Getting rid of plaintext secrets

```bash
# get the latest revision of the backup
etcdctl --write-out=table snapshot status backup.db

# compact the data of the db
# eg etcdctl compact 33864
etcdctl compact <REVISION>

# create a new snapshot
etcdctl snapshot save backup2.db

# verify that the password is in plain text - most of the time it is, we have to trigger a defragmentation manually
cat backup2.db | grep -a password123

# execute a defragmentation of the db
etcdctl defrag

# create a new snapshot
etcdctl snapshot save backup3.db

# verify that the password is not in plain text
cat backup3.db | grep -a password123
```
