# KKP Administration

In this training you will setup KKP on GCE.


## Setup Environment

### Prepare Google Cloud Shell

#### Allow Cookies

If you are in Incognito Mode you may get this message:

![](../img/cookies_01.png)

Open this dialogue:

![](../img/cookies_02.png)

Allow Cookies:

![](../img/cookies_03.png)

#### Select Home Directory

![](../img/open_home_workspace.png)

#### Open a new tab

![](../img/choose_project.png)

#### Verify Environment Variables are set

```bash

# TODO fix repo after transition to codespaces
rm -rf ~/.tmp
mkdir -p ~/.tmp
git clone https://github.com/cloudnativetrainings/trainings.git ~/.tmp
cp -r ~/.tmp/kubermatic_kubernetes_platform_administration/* ~ 

set .trainingrc project variable
# TODO add .trainingrc to .bashrc

source ~/.trainingrc
make verify
```

### Set GCE Credentials

```bash
make get_gcp_sa_key
export GOOGLE_CREDENTIALS=$(cat ~/secrets/key.json)
```

Verify Google Credentials via

```bash
echo $GOOGLE_CREDENTIALS
```

### Create SSH key pair

```bash
ssh-keygen -N '' -f ~/secrets/kkp_admin_training
eval `ssh-agent`
ssh-add ~/secrets/kkp_admin_training
```

### Install tools

```bash
make install_tools
```

### Install bash completion

```bash
source <(kubectl completion bash)
```
