
<!-- TODO slides what is package management -->

```bash

apt install tree
=> FAIL

apt update
=> ignore upgradable packages

apt install tree

ls -alh
tree

apt upgrade
=> No

apt upgrade -y
# TODO fix linux versions => no reboot should be needed in this phase

apt update && apt upgrade -y

# TODO install docker
https://docs.docker.com/engine/install/ubuntu/

apt list --installed

apt list --installed | grep tree

which tree

apt remove tree

which tree


```