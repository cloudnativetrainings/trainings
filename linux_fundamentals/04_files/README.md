
# file manipulation
```bash

cd

touch my-file.txt
ls -alh 
cat my-file.txt

echo "something" > my-file.txt
cat my-file.txt

echo "something again" > my-file.txt
cat my-file.txt

echo "something again" >> my-file.txt
cat my-file.txt

cp my-file.txt my-copy-of-my-file.txt
ls -alh

mv my-copy-of-my-file.txt my-moved-copy-of-my-file.txt
ls -alh

rm my-moved-copy-of-my-file.txt
ls -alh

mkdir my-dir-to-be-deleted
rm my-dir-to-be-deleted
=> error
rm -d my-dir-to-be-deleted
ls -alh
```

# reading files
```bash

# TODO slides expain pipe
cat my-file.txt | grep again

cat my-file.txt | wc -l
cat my-file.txt | wc -c

# big files
cat /var/log/syslog
cat my-file.txt | grep error
less /var/log/syslog
head /var/log/syslog
head -n 3 /var/log/syslog
tail -n 3 /var/log/syslog
```

# vi

```bash
vi my-file.txt

# TODO slides vi joke 
# TODO slides nano, emacs and other crap
i
insert something
esc
wq

i
insert something wrong
esc
q!

```

