# links
https://artifacthub.io/packages/helm/bitnami/postgresql
TODO https://artifacthub.io/packages/helm/bitnami/postgresql-ha

# add helm repo
helm repo add bitnami https://charts.bitnami.com/bitnami

# configuration possibilities
helm show values bitnami/postgresql-ha --version 9.0.4 > postgres_default_values.yaml

# dry-run
helm install --create-namespace --namespace postgres my-postgres bitnami/postgresql-ha --version 9.0.4 --dry-run > postgres_dry_run.yaml

# install
helm install --create-namespace --namespace postgres my-postgres bitnami/postgresql-ha --version 9.0.4

export POSTGRES_PASSWORD=$(kubectl get secret --namespace postgres-2 my-postgres-postgresql-ha-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)

echo $POSTGRES_PASSWORD

export REPMGR_PASSWORD=$(kubectl get secret --namespace postgres-2 my-postgres-postgresql-ha-postgresql -o jsonpath="{.data.repmgr-password}" | base64 --decode)

kubens postgres

kubectl get all

# use client to connect to db
kubectl run my-postgres-postgresql-client --rm --tty -i --restart='Never' --namespace postgres --image docker.io/docker.io/bitnami/postgresql-repmgr:14.2.0-debian-10-r70 --env="PGPASSWORD=$POSTGRES_PASSWORD" \
      --command -- psql --host my-postgres-postgresql-ha-postgresql -U postgres -d postgres -p 5432

kubectl run my-postgres-postgresql-ha-client --rm --tty -i --restart='Never' --namespace postgres --image docker.io/bitnami/postgresql-repmgr:14.2.0-debian-10-r70 --env="PGPASSWORD=$POSTGRES_PASSWORD"  \
    --command -- psql -h my-postgres-postgresql-ha-pgpool -p 5432 -U postgres -d postgres      

CREATE DATABASE test;
\c test
CREATE TABLE test_table(something int);
INSERT INTO test_table VALUES (123);
SELECT * FROM test_table;
\q      


    kubectl run my-postgres-postgresql-ha-client --rm --tty -i --restart='Never' --namespace postgres-2 --image docker.io/bitnami/postgresql-repmgr:14.2.0-debian-10-r70 --env="PGPASSWORD=$POSTGRES_PASSWORD"  \
        --command -- psql -h my-postgres-postgresql-ha-pgpool -p 5432 -U postgres -d postgres


export POSTGRES_PASSWORD=$(kubectl get secret --namespace postgres-2 my-postgres-postgresql-ha-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
