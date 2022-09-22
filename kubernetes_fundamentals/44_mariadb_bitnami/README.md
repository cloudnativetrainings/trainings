# links
https://artifacthub.io/packages/helm/bitnami/mariadb

# add repo
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# configuration possibilities
helm show values bitnami/mariadb --version 11.0.1 > mariadb_default_values.yaml

# dry-run
helm install my-mariadb bitnami/mariadb --version 11.0.1 --dry-run > mariadb_dry_run.yaml

# install
helm install my-mariadb bitnami/mariadb --version 11.0.1

# use client to connect to db
kubectl get secret --namespace default my-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode

Qthfyj1aOH

kubectl run my-release-mariadb-client --rm --tty -i --restart='Never' --image  docker.io/bitnami/mariadb:10.6.7-debian-10-r69 --namespace default --command -- bash

mysql -h my-mariadb -uroot -p my_database

CREATE TABLE test_table(something int);
INSERT INTO test_table VALUES (123);
SELECT * FROM test_table;


