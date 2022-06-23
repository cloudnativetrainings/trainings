
git clone https://github.com/kubermatic-labs/trainings.git 

choose project in google cloud shell

<!-- TODO remove v2 -->
cd ~/trainings/kkp_fundamentals_v2/00_cloud_credentials
<!-- TODO maybe clone only subdir -->

# set gcp credentials
make get_gcp_sa_key
export GOOGLE_CREDENTIALS=$(cat ~/key.json)

# create ssh key pair
ssh-keygen -N '' -f ~/.ssh/kkp_admin_training
eval `ssh-agent`
ssh-add ~/.ssh/kkp_admin_training
