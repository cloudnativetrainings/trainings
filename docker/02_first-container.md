# First Container

## Hello World

In your Docker environment, simply run this command:

`docker run alpine echo hello world`
 
* `run` a command in a new container
* `alpine` is one of the smallest Linux systems  
* `echo hello world` is the command which is executed 

## Run an Apache in a Container

For interactive processes (like a shell), you must use `docker run` with `-i` `-t` together in order to allocate a tty for the container process. `-i` `-t` is often written `-it`. 

To expose a container's internal port, you can start the container with the `-P` or `-p` flag. The exposed port is accessible on the host and the ports are available to any client that can reach the host.

Now start a new container to install Apache trough the package manger - execute:

`docker run -it -p 80:80 ubuntu`
   
Now, let's install it:

`apt-get update && apt-get install -y apache2`

Start the Apache: 

`apache2ctl -DFOREGROUND`

TODO
Test access to website, got to: https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com


## Stop the Container

Exit the process with (E.g. with `^C`) as you normally would do: `echo "Send Ctrl+C to Terminal"`{{execute interrupt}}

Exit the shell with `^D` or type `exit`.

The container is stopped  but it still exists on disk. You can take a look:

`docker ps -a`

To delete all running and stopped container execute:

`docker rm $(docker ps -aq)`

Check if the containers get deleted:
 
`docker ps -a`

TODO check if katacoda or execute is somewhere in
