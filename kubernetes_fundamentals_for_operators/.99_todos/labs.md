# add not really optional k8s stuff

* metrics server
* ccm
* ...

# 000_func.sh
coud func() not be part of .trainingrc mechanisms... eg public ip

# teardown
make teardown.sh idempotent

# Add more content to READMEs
* attendees should do "manual" verification step

# kubeconfig for doing later labs should be automated in some way

# teardown persistent disks in gcp
as it looks they are not deleted

# single source of truth
export REGION=europe-west3
export ZONE=europe-west3-a

should be done in the makefile to be passed into the shell scripts
