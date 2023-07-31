# Container Fundamentals

**Pre-requisites:**

1. Navigate and login to [Google Cloud Shell](https://ssh.cloud.google.com ) via web browser.

2. Clone the Kubermatic trainings git repository:

    ```bash
    git clone https://github.com/kubermatic-labs/trainings.git
    ```

3. Navigate to Container Fundamentals training folder to get started

    ```bash  
    cd trainings/container_fundamentals/
    ```

# TODO
4. make create, make connect
# TODO


## Install docker

```bash
# Update apt package index and install necessary dependencies
apt-get install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Setup the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install docker
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```
