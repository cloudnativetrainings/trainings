# Hello Linux

In this lab you will learn some basic commands to communicate with Linux.

## Getting some Info

```bash
# getting info about yourself
whoami

# getting the current directory
pwd
```

## Working with Directories

```bash
# create a directory
mkdir my-dir

# list the content of the current directory
ls -alh

# create a subdirectory (the command will fail due to the directory `my-parent-dir` does not exist yet)
mkdir my-parent-dir/my-sub-dir

# getting help about the mkdir command, try to find the right argument on your own
mkdir --help

# also the man pages give you further information about 
man mkdir

# now create the directory with the `--parents` argument
mkdir -p my-parent-dir/my-sub-dir
ls -alh

# jump into the sub directory
cd my-parent-dir/my-sub-dir
pwd

# jump into the parent directory
cd ..

# jump into the home directory
cd ~

# jump into the previous directory
cd -

# print out some text
echo "hello linux"
```

## Working with Environment Variables

```bash
# print out all environment variables
env

# add an environment variable
export MY_ENV_VAR="my value"
env

# print out the environment variable (you can avoid typing some characters via clicking tab after entering `echo $MY_`)
echo $MY_ENV_VAR
```


TODO slides file structure of linux
