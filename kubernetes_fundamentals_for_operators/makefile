TRAINING_RC_FILE=~/.trainingrc

.PHONY setup:
setup:
	grep -qxF "source $(TRAINING_RC_FILE)" ~/.bashrc || echo "source $(TRAINING_RC_FILE)" >> ~/.bashrc
	./setup_gcp_params.sh
