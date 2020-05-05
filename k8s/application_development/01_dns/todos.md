
# prerequits
* my-app is running

# steps
## build and push curl image

## create namespace 

## run job and try to fix the issue
* kubectl -n my-namespace get jobs
* kubectl -n my-namespace get pods
* add default and port to the command   args: [ "my-app.default:8080" ]
* delete the job and retry

# verification
* check if job was successful
