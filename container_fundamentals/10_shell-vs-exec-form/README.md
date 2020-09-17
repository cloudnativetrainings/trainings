# Shell vs exec form

In this training you will learn a difference between shell and exec form.

## Inspect the Dockerfile 

## Build the image

```bash
docker build -t shell-vs-exec-form:1.0.0 .
```

## Run a container from the image

```bash
docker run -it shell-vs-exec-form:1.0.0
```

Note that variable substitution for the environment variable $FOO did not happen.

## Change the entrypoint to the following in the Dockerfile

```
ENTRYPOINT /bin/echo $FOO
```

## Build the image

```bash
docker build -t shell-vs-exec-form:2.0.0 .
```

## Run a container from the image

```bash
docker run -it shell-vs-exec-form:2.0.0
```

Note that variable substitution happened this time.
