# Kubernetes Fundamentals

## Setup training environment

1. Navigate and login to [Google Cloud Shell](https://ssh.cloud.google.com ) via web browser.

2. Clone the Kubermatic trainings git repository:

```bash
git clone https://github.com/kubermatic-labs/trainings.git
```

3. Navigate to Kubernetes Fundamentals training folder to get started

```bash
cd trainings/kubernetes_fundamentals/
```

4. Create the training environment

```bash
make setup
```

5. Bring in some convenience into training environment

```bash
source ~/.trainingrc
```

## Verify training environment

```bash
make verify
```

## Teardown training environment

```bash
make teardown
```
