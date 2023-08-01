# Linting Dockerfiles

In this training, we will make use of a linter for Dockerfiles.

>Navigate to the folder `12_linting` from CLI, before you get started.

## Inspect the Dockerfile

```bash
cat Dockerfile
```

## Lint the Dockerfile

```bash
hadolint Dockerfile
```

You will get some warning and info messages like these

```bash
Dockerfile:1 DL3006 warning: Always tag the version of an image explicitly
Dockerfile:3 DL3009 info: Delete the apt-get lists after installing something
Dockerfile:4 DL3059 info: Multiple consecutive `RUN` instructions. Consider consolidation.
Dockerfile:5 DL3008 warning: Pin versions in apt get install. Instead of `apt-get install <package>` use `apt-get install <package>=<version>`
Dockerfile:5 DL3059 info: Multiple consecutive `RUN` instructions. Consider consolidation.
Dockerfile:5 DL3015 info: Avoid additional packages by specifying `--no-install-recommends`
Dockerfile:7 DL3025 warning: Use arguments JSON notation for CMD and ENTRYPOINT arguments
```

Fix all warning messages and try to fix some info messages in the Dockerfile and run hadolint for verification of your work.