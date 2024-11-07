# Kubermatic Kubernetes Platform Administration

## Prepare Google Cloud Shell

### Allow Cookies

If you are in Incognito Mode you may get this message:

![](../img/cookies_01.png)

Open this dialogue:

![](../img/cookies_02.png)

Allow Cookies:

![](../img/cookies_03.png)

### Select Home Directory

![](../img/open_home_workspace.png)

### Open a new tab

![](../img/choose_project.png)

## Setup Environment

```bash
# get the training materials
mkdir -p ~/.tmp
git clone https://github.com/cloudnativetrainings/trainings.git ~/.tmp
cp -r ~/.tmp/kubermatic_kubernetes_platform_administration/* ~
cp -r ~/.tmp/kubermatic_kubernetes_platform_administration/.trainingrc ~/.trainingrc

# setup the Google Cloud Project in .trainingc file

# create folders
mkdir -p ~/secrets
mkdir -p ~/bin

# create SSH key-pair
ssh-keygen -N '' -f ~/secrets/kkp_admin_training

# get the Google Credentials and add it to the .trainingrc file
source ~/.trainingrc
make get-google-credentials
echo "export GOOGLE_CLOUD_KEYFILE_JSON=~/secrets/key.json" >> ~/.trainingrc

# re-source the .trainingrc file again
source ~/.trainingrc

# verify the environment
make verify
```
