# Bash

In this lab you will learn how to search your bash commands you did in the past and how you can customize your bash.

## Shells in Linux

```bash
# see all installed shells
cat /etc/shells

# see the current shell
echo $SHELL

# change to a different shell
chsh
```

## Customizing Bash

You can change the bash behaviour and look and feel via inserting valid bash commands into the file '~/.bashrc'. This file gets considered each time you login to a machine. For example you can use it for 
* Setting of Environment Variables
* Creation of Aliases
* Triggering executables
* Changing the look and feel of your Bash

```bash
# install a weather tool
apt install ansiweather

# try it
ansiweather -l vienna

# add an alias for the weather tool in your ~/.bashrc file
echo "alias my-alias='ansiweather -l vienna'" >> ~/.bashrc

# take a look at the last line of your ~/.bashrc file
cat ~/.bashrc

# the changes are not engaged yet, if you re-connect to the machine they become active, but you can also source the ~/.bashrc file
. ~/.bashrc

# try the alias
my-alias

# execute the weather tool each time you login to the machine
echo "my-alias" >> ~/.bashrc

# the changes are not engaged yet, if you re-connect to the machine they become active, but you can also source the ~/.bashrc file
. ~/.bashrc
```

## Changing the Bash Prompt

```bash
# open the ~/.bashrc file via vi
vi ~/.bashrc

# add this line at the end of your ~/.bashrc file
PS1='\[\033[1;73m\][$(date +%H:%M:%S)]\[\033[1;36m\][\[\033[1;34m\]\u\[\033[1;33m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\w\[\033[1;36m\]]\[\033[1;31m\]\\$\[\033[0m\] '

# the changes are not engaged yet, if you re-connect to the machine they become active, but you can also source the ~/.bashrc file
. ~/.bashrc
```

## History

```bash
# you can see your bash history in this file
cat ~/.bash_history

# or you can use the history command
history

# you can search the history inline (via clicking again <CTRL>+<R> you can navigate in the history)
<CTRL>+<R>
cat
<CTRL>+<R>
```
