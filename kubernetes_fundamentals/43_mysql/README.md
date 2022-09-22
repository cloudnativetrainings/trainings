# Run a MySql DB

In this training you will run a mysql db and use it.

>Navigate to the folder `43_mysql` from CLI, before you get started. 

## Create the DB
Inspect pvc,yaml, deployment.yaml and service.yaml definition file and create the resources.
```bash
cat pvc.yaml
cat deployment.yaml
cat service.yaml
kubectl create -f pvc.yaml,deployment.yaml,service.yaml
```

## Use the DB
```bash
# Run a second mysql pod as a client of the db
kubectl run -it --rm --image mysql:5.6 my-mysql-client -- mysql -hmy-mysql -uroot -ppassword

# create and use db
create database my_db;
show databases;
use my_db;

# create a table
create table tasks(
   task_id INT NOT NULL AUTO_INCREMENT,
   task_name VARCHAR(100) NOT NULL,
   PRIMARY KEY ( task_id )
);
show tables;

# insert data into table
insert into tasks(task_id,task_name) values (43,"mysql");
select * from tasks;

# exit the mysql client pod
exit
```

# Delete the DB Pod
```bash
kubectl delete pod <MY-MYSQL-POD>
kubectl get pods
```

# Verify that the data is still available
```bash
# Run a second mysql pod as a client of the db
kubectl run -it --rm --image mysql:5.6 my-mysql-client -- mysql -hmy-mysql -uroot -ppassword

# Verify that the data still exists
select * from my_db.tasks;

# exit the mysql client pod
exit
```

# Verify the data in the DB Pod
```bash
kubectl exec -it <MY-MYSQL-POD> -- ls -alh /var/lib/mysql/my_db
```

## Cleanup
Delete the created resources.
```bash
kubectl delete -f deployment.yaml,pvc.yaml,service.yaml
```
