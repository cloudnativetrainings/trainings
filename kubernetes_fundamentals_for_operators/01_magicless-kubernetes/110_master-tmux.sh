#!/bin/bash

### NOTE!!!
# on gcloud shell, disable tmux!!! 

set -euxo pipefail

source ~/.trainingrc

tmux new-session -d -s magicless-master
tmux split-window -t magicless-master:0.0
tmux split-window -t magicless-master:0.0
tmux select-layout -t magicless-master:0 even-vertical

tmux send-keys -t magicless-master:0.0 'gcloud compute ssh master-0' C-m
tmux send-keys -t magicless-master:0.1 'gcloud compute ssh master-1' C-m
tmux send-keys -t magicless-master:0.2 'gcloud compute ssh master-2' C-m

tmux setw synchronize-panes on

tmux att -t magicless-master
