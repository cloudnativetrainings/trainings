# Privileged Container
In this course we will get full access to on the host.

1. Create a Container
```bash
docker run -it --rm ubuntu bash
```
2. Show all processes and exit the container
```bash
ps aux
exit
```
3. Create a privileged Container with access to the process tree of the host
```bash
docker run -it --rm --privileged --pid host -v /:/host ubuntu bash
```
4. Show all processes and exit the container
```bash
# Show all processes
ps aux
# See the filesystem of the host
ls -alh /host
```
