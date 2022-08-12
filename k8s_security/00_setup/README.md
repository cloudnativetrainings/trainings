
set project in terminal

git clone https://github.com/kubermatic-labs/trainings

cd trainings/k8s_security/00_setup/

make create

gcloud compute instances list

gcloud compute ssh root@kubernetes-security

sudo su

kubectl get nodes

cd /root

