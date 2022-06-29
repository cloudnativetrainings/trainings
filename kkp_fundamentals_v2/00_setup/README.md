
mkdir -p ~/.tmp
git clone https://github.com/kubermatic-labs/trainings.git ~/.tmp/trainings
<!-- TODO remove v2 -->
cp -r ~/.tmp/trainings/kkp_fundamentals_v2/* .

choose project in google cloud shell

<!-- going master/seed !!! due to monitoring and config file madness -->

<!-- TODO go big with the machines due MLA n1 standard 4 -->
<!-- TODO enable auto-scaling -->

source <(kubectl completion bash)

cd ~/00_setup

# set gcp credentials
make get_gcp_sa_key
export GOOGLE_CREDENTIALS=$(cat ~/secrets/key.json)

# create ssh key pair
ssh-keygen -N '' -f ~/secrets/kkp_admin_training
eval `ssh-agent`
ssh-add ~/secrets/kkp_admin_training

<!-- maybe not necessary -->
<!-- # gcloud init 
Pick configuration to use:
 [1] Re-initialize this configuration [cloudshell-21560] with new settings
 [2] Create a new configuration

name

Choose the account you would like to use to perform operations for this configuration:
 [1] student-01.kkp-admin-training@loodse.training
 [2] Log in with a new account
Please enter your numeric choice:  1

Pick cloud project to use:
 [1] student-01-kkp-admin-training
 [2] Enter a project ID
 [3] Create a new project
Please enter numeric choice or text value (must exactly match list item):  1

Do you want to configure a default Compute Region and Zone? (Y/n)?  y
Please enter numeric choice or text value (must exactly match list item):  21 -->