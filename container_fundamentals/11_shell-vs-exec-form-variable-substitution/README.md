# Shell vs exec form - variable substitution

In this training, you will learn the difference between shell and exec form concerning variable substitution.

## Inspect the Dockerfile 
```bash
cat Dockerfile
```

## Build the image
```bash
docker build -t shell-vs-exec-form-vars:1.0.0 .
```

## Run a container from the image
```bash
docker run -it shell-vs-exec-form-vars:1.0.0
```
>Note that variable substitution for the environment variable $FOO did not happen.

## Change the entrypoint to the following in the Dockerfile
```
ENTRYPOINT /bin/echo $FOO
```

## Build the image
```bash
docker build -t shell-vs-exec-form-vars:2.0.0 .
```

## Run a container from the image
```bash
docker run -it shell-vs-exec-form-vars:2.0.0
```
>Note that variable substitution happened this time.

## Cleanup
Remove all the containers
```bash
docker rm -f $(docker ps -qa)
```

[Jump to Home](../README.md) | [Previous Training](../10_entrypoint-vs-cmd/README.md) | [Next Training](../12_shell-vs-cmd-form-PID1/README.md)