# Files

In this lab you will learn how to manage and edit files.

## Writing Files
```bash

# Create a file
touch my-file.txt
ls -alh 

# Print out a file (note the file has no content yet)
cat my-file.txt

# echo something into a file
echo "something" > my-file.txt
cat my-file.txt

# echo something different into a file again (note that the content gets overwritten)
echo "something again" > my-file.txt
cat my-file.txt

# append something different into a file again
echo "something again, the 2nd time" >> my-file.txt
cat my-file.txt

# copy a file
cp my-file.txt my-copy-of-my-file.txt
ls -alh

# move/rename a file
mv my-copy-of-my-file.txt my-moved-copy-of-my-file.txt
ls -alh

# remove a file
rm my-moved-copy-of-my-file.txt
ls -alh

# removing directories (note you will get an error on removing the directory)
mkdir my-dir-to-be-deleted
rm my-dir-to-be-deleted

# retry with the directory flag
rm -d my-dir-to-be-deleted
ls -alh
```

# Reading Files
```bash

# print out all lines containing the word 'the'
cat my-file.txt | grep the

# count the lines containing the word 'the'
cat my-file.txt | grep the | wc -l

# count all characters in the file
cat my-file.txt | wc -c

# for bigger files the command cat is not helpful
cat /var/log/syslog

# you can grep for specific phrases 
cat /var/log/syslog | grep error

# you can also grep ignoring the case
cat /var/log/syslog | grep -i ERROR

# you can also grep using regular expressions
cat /var/log/syslog | grep -i '^.*kernel.*docker.*$'

# navigating through files (via arrow down and up, to escape less click q)
less /var/log/syslog

# showing the first lines of a file
head /var/log/syslog

# showing the first 3 lines of a file
head -n 3 /var/log/syslog\

# showing the last 3 lines of a file
tail -n 3 /var/log/syslog

# wait for new data to the file and follow
tail -f /var/log/syslog
```

# vi
```bash
# edit a file in vi
vi my-file.txt

# to get into the insert mode click `i` and add some text
insert something

# save file and exit vi
<ESC>
:wq<ENTER>

# alternatively if you want to discard your changes
<ESC>
:q!<ENTER>
```

TODO slides nano, emacs and other crap
TODO slides vi jokes
TODO linux philosophy about chaining commands
TODO slides expain pipe
