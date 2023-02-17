# Bash Scripts

In this lab you will learn how to write your own bash scripts.

## Create your own bash script

Create a file called `my-bash-script.sh` via vi with the following content
>#!/bin/bash
>
>echo $(date) >> my-bash-script-file.txt

```bash
# try to run the bash script (which will fail due to it is not executable yet)
./my-bash-script.sh

# make the bash script executable
ls -alh
chmod 700 my-bash-script.sh
ls -alh

# run the bash script
./my-bash-script.sh

# verify the bash script worked out
cat my-bash-script-file.txt
```
