# Kubernetes Fundamentals

## Setup training environment

1. Navigate and login to [Google Cloud Shell](https://ssh.cloud.google.com) via web browser.
1. Clone the Kubermatic trainings git repository: `git clone https://github.com/cloudnativetrainings/trainings.git`
1. Navigate to Kubernetes Fundamentals training folder to get started: `cd trainings/kubernetes_fundamentals_for_operators/`
1. Please deactivate Tmux in the Google Cloud Shell.
1. Create the training environment: `make setup`
1. Bring in some convenience into training environment`source ~/.trainingrc`

## Verify training environment

```bash
make verify
```

## Teardown training environment

```bash
make teardown
```
