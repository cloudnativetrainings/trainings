# backup
etcdctl snapshot save backup.db

cat backup.db | grep -a password123

cat backup.db | grep -a password456

# fix old data in backup

etcdctl --write-out=table snapshot status backup.db

etcdctl compact 33864

etcdctl snapshot save backup.db

cat backup.db | grep -a password123
=> does not work

etcdctl defrag

etcdctl snapshot save backup.db

cat backup.db | grep -a password123
=> should work

