#!/bin/bash

set -euxo pipefail

### NOTE!!!
# on gcloud shell, disable tmux!!! 
# unset TMUX
# set project in terminal

for node in master-{0..2}; do
  gcloud compute scp 065_master-etcd.sh 070_master.sh ${node}:
done

tmux new-session -d -s magicless-master
tmux split-window -t magicless-master:0.0
tmux split-window -t magicless-master:0.0
tmux select-layout -t magicless-master:0 even-vertical

tmux send-keys -t magicless-master:0.0 'gcloud config set compute/zone europe-west3-a; gcloud compute ssh master-0' C-m
tmux send-keys -t magicless-master:0.1 'gcloud config set compute/zone europe-west3-a; gcloud compute ssh master-1' C-m
tmux send-keys -t magicless-master:0.2 'gcloud config set compute/zone europe-west3-a; gcloud compute ssh master-2' C-m

tmux setw synchronize-panes on

tmux att -t magicless-master
