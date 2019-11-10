# Interacting

## Run container in foreground

In foreground mode (by default when -d is not specified), docker run can start 
the process in the container and attach the console to the process' standard 
input, output, and standard error. 
It can even pretend to be a TTY (this is what most command line executables 
expect) and pass along signals.
```bash
docker run -t -p 80:80 loodse/demo-www
```

To stop it, press ^C.

## Detached container

To start a container in detached mode, use `-d=true` or just `-d` option. 
By design, containers exit when the root process used to run the container exits.
```bash
docker run -d -t -p 801:80 loodse/demo-www
```

## Detaching from a running container

Run a container.
```bash
docker run -it --name counter loodse/counter
```

It will create and run a new container with name `counter` from image 
`loodse/counter` and will print a a numbers in increasing fashion on screen.

You can detach from this running container using `CTRL-p CTRL-q` key sequence.

## Attaching to running container

You can use `docker attach` to attach.

Spawn a new container using 
```bash
docker run -d -it --name counter1 loodse/counter
```

It will start a container in detached mode using `-d` flag.

You can attach local standard input, output, and error streams to a running 
container using 
```bash
docker attach counter1
```

## List containers

You can list containers using 
```bash
docker ps
```

The docker ps command only shows running containers by default. To see all 
containers, use the `-a` (or `--all`) flag.
```bash
docker ps -a
```

## Stop a running container

Start a new container using 
```bash
docker run -d -it --name counter loodse/counter
```

You can stop a running container using 
```bash
docker stop counter
```

## Kill a container

Start a new container using 
```bash
docker run -d -it --name newcounter loodse/counter
```

You can kill a container using 
```bash
docker kill newcounter
```

The main process inside the container will be sent `SIGKILL`, or any signal 
specified with option `--signal`.

## Check the container logs

Create a new container with name `test` from `busybox` image.
```bash
docker run --name test -d busybox sh -c "while true; do $(echo date); sleep 1; done"
```

Check logs using 
```bash
docker logs test
```

You can get follow the logs using 
```bash
docker logs test --follow
```