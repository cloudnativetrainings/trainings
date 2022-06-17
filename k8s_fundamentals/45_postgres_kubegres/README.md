# docs

https://www.kubegres.io/doc/getting-started.html

# Replicated DB

kubectl apply -f https://raw.githubusercontent.com/reactive-tech/kubegres/v1.15/kubegres.yaml

kubectl -n kubegres-system get all

kubectl get sc

kubectl create -f secret.yaml

kubectl create -f pg-cluster.yaml

kubectl get all

# client

## insert data into master 

kubectl run -it postgres-master-client --image postgres:14.1 -- bash

psql postgresql://postgres:superUserPassword@my-postgres-db:5432/postgres

CREATE DATABASE test;
\c test
CREATE TABLE test_table(something int);
INSERT INTO test_table VALUES (123);
SELECT * FROM test_table;
\q

## get data from replica

kubectl run -it postgres-replica-client --image postgres:14.1 -- bash

psql postgresql://postgres:superUserPassword@my-postgres-db-replica:5432/postgres

\c test
SELECT * FROM test_table;
\q

# Cleanup

kubectl delete ns kubegres-system

kubectl delte all --all

