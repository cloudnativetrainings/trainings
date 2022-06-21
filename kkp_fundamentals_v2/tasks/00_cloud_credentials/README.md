
git clone https://github.com/kubermatic-labs/trainings.git 

choose project in google cloud shell

<!-- TODO remove v2 -->
cd ~/trainings/kkp_fundamentals_v2/tasks/00_setup

# set gcp credentials
make get_gcp_sa_key
export GOOGLE_CREDENTIALS=$(cat ~/key.json)


