# Container Fundamentals

## Setting up the lab environment

1. Navigate and login to [Google Cloud Shell](https://ssh.cloud.google.com ) via web browser.

2. Clone the Kubermatic trainings git repository:

  ```bash
  git clone https://github.com/kubermatic-labs/trainings.git
  ```

3. Navigate to Container Fundamentals training folder to get started

  ```bash  
  cd trainings/container_fundamentals/
  ```

4. Create the VM via 

  ```bash  
  make create
  ```

4. Connect to the VM via

  ```bash  
  make connect
  ```

## Destroying the lab environment

  ```bash  
  make destroy
  ```
