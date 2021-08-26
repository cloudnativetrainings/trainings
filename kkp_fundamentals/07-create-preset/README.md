# Create Preset for GCP

In the previous step, you have created a User Cluster by providing Service Account value in the UI.

You can create "Preset" for each provider by following these steps.

```bash
cd $TRAINING_DIR # folder 'kkp_fundamentals'
cp $TRAINING_DIR/07-create-preset/gce.preset.yaml $TRAINING_DIR/src/kkp-setup/
SA_KEY_ENCODED=`base64 -w 0 ./.secrets/k8c-cluster-provisioner-sa-key.json`
cd $TRAINING_DIR/src/kkp-setup/
sed -i 's/<INSERT-SERVICE-ACCOUNT-VALUE>/'"$SA_KEY_ENCODED"'/g' gce.preset.yaml
cat gce.preset.yaml
kubectl apply -f gce.preset.yaml
```

Now go back to the Kubermatic Dashboard and try to create User cluster again, at the **Settings** step, you will be
able to select created Preset and with that you don't have to provide credentials in the UI.
