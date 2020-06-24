# Create an Ubuntu VM on GCE

1. Go to `Compute Instances` page: https://console.cloud.google.com/compute/instances

2. Create a standard ubuntu VM in your region
  ![](./.pics/gce-machine.png)

3. Test the connection trough SSH window/console
  - Execute:
    ```bash
    gcloud config set project student-XX
    gcloud compute ssh docker-host --zone europe-west4-a    
    ```
  - Or open a new browser window
    ![](./.pics/gce_ssh.png)