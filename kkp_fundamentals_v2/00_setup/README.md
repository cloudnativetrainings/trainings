mkdir -p ~/.tmp
git clone https://github.com/kubermatic-labs/trainings.git ~/.tmp/trainings
<!-- TODO remove v2 -->
cp -r ~/.tmp/trainings/kkp_fundamentals_v2/* .

choose project in google cloud shell

cd ~/00_setup

# set gcp credentials
make get_gcp_sa_key
export GOOGLE_CREDENTIALS=$(cat ~/secrets/key.json)

# create ssh key pair
ssh-keygen -N '' -f ~/secrets/kkp_admin_training
eval `ssh-agent`
ssh-add ~/secrets/kkp_admin_training
