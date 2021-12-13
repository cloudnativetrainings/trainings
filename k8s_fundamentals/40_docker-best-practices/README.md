# use eg node image not ubuntu and install node on it
# do not use :latest image tag
# use execform
# use ENTRYPOINT & CMD
# do not run as root
# do not run as privilegd
# small images
# multistaged builds
# use read-only file system
# use caching wisely - order of things
# application log to stdout
# .dockerignore
# no credentials in image
# apt update???
# use of && in apt => one layer
# use WORKDIR
# use aquasec trivy

# koray
buildkit
hadolint
skopeo