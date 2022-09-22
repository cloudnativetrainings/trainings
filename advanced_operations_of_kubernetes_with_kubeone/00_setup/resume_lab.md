# Resume Lab environment

If you were using a Cloud Shell Environment of refreshed your local environment, these are the steps to be performed to start quickly.

Make sure that these steps are executed inside the Tooling Container (if you are using it).

```bash
docker run --name kubeone-tool-container -v $(pwd):/home/kubermatic/mnt -t -d quay.io/kubermatic-labs/kubeone-tooling:1.4.2
docker exec -it kubeone-tool-container bash
```

```bash
export GCP_PROJECT_ID=student-xx-xxxx
export GCP_SERVICE_ACCOUNT_ID=k1-service-account@student-xx-xxxx.iam.gserviceaccount.com
export TRAINING_DIR=/home/kubermatic/mnt/trainings/k1_fundamentals
$TRAINING_DIR/00_setup/setup.sh
export GOOGLE_CREDENTIALS=$(cat $TRAINING_DIR/.secrets/k8c-cluster-provisioner-sa-key.json)
eval `ssh-agent`
ssh-add $TRAINING_DIR/.secrets/id_rsa
export KUBECONFIG=$TRAINING_DIR/src/gce/k1-kubeconfig
```