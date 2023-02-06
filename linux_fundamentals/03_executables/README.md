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

ls -alh

# explain dot
./my-executable

cd 

./my-executable
=> does not work

which my-executable
=> does not work

mv trainings/linux_fundamentals/03_executables/my-executable /usr/local/bin

which my-executable

./my-executable

```

start application in background

htop

ps aux

kill -9