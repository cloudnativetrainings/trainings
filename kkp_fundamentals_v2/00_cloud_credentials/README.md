
git clone https://github.com/kubermatic-labs/trainings.git 

<!-- TODO move subdir kkp_fundamentals to root -->
<!-- TODO rename tmp to .tmp -->

choose project in google cloud shell

<!-- TODO remove v2 -->
cd ~/trainings/kkp_fundamentals_v2/00_cloud_credentials
<!-- TODO maybe clone only subdir -->

# set gcp credentials
make get_gcp_sa_key
export GOOGLE_CREDENTIALS=$(cat ~/key.json)
<!-- TODO maybe move that stuff into secrets folder, also the kubeconfigs -->

# create ssh key pair
<!-- TODO put keys into secret folder? -->
ssh-keygen -N '' -f ~/.ssh/kkp_admin_training
eval `ssh-agent`
ssh-add ~/.ssh/kkp_admin_training
