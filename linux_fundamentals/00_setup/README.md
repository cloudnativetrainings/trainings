# Provision VM 

## Open Google Cloud Console Run the setup.sh bash script

You will be asked to enter the project name.

```bash
00_setup/setup.sh
```

## SSH into the new VM

```bash
gcloud compute ssh root@training-lf --zone europe-west3-a
```
# TODO maybe automate that stuff so no unlearned linux commands are needed
2. Clone the Kubermatic trainings git repository:

    ```bash
    git clone https://github.com/kubermatic-labs/trainings.git
    ```

3. Navigate to Linux Fundamentals training folder to get started

    ```bash  
    cd trainings/linux_fundamentals/
    ```
