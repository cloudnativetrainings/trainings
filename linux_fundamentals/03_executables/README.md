# Executables

In this lab you will learn how to handle executables and we will create our own small application.

## The path for executables in Linux

```bash
# the path in linux is an environment variable, lets take a look at it
echo $PATH

# one of the entries is the following folder (currently nothing is in it)
ls -alh /usr/local/bin
```

## Creating a small application

```bash
# for our application we will need golang on our box, lets look if it is installed 
which go

# due to it does not exist we have to install it
apt install golang

# check if it got installed properly
go version

# take a look at the sourcecode
cat 03_executables/my-executable.go

# build the application
go build 03_executables/my-executable.go

# the executable with the name `my-executable` should now exist
ls -alh

# lets start our application, note the `./` before the name of the executable
./my-executable

# stopping the application
<CTRL>+<C>
```

## Adding the application to the path
```bash
# if you try to run the application from a different folder it will not work out
cd ~
./my-executable
which my-executable

# lets move the executable to the folder /usr/local/bin (which is in the PATH environment variable)
mv trainings/linux_fundamentals/my-executable /usr/local/bin

# now our application is known by the Linux system
which my-executable
my-executable
<CTRL>+<C>
```

## Process Management

```bash
# switch back to the training folder
cd ~/trainings/linux_fundamentals

# lets start application in background and redirect stdout and stderr
my-executable > my-executable.log 2>&1 & 

# verify the application is running
cat my-executable.log

# lets find the process id for our application
ps aux

# due to this is too much output we grep the line with our application
ps aux | grep my-executable

# lets kill our application
# get the process id via the previous command, it is in the second column
kill -9 PROCESS_ID

# the "task manager" on our box
htop
```

TODO slides explain dot on starting executables
TODO slides stderr stdout
