# Cronjobs

In this lab you will learn how to schedule processes periodicaly.

```bash

# list all existing cronjobs (none, yet)
crontab -l

# open the cronjob editor
crontab -e

# add a cronjob via appending the following line (which executes the command every minute)
* * * * * echo $(date) >> ~/trainings/linux_fundamentals/cron_output.log

# verify the cronjob is working (maybe you have to wait for a minute for it), you can exit the command `watch` via <CTRL>+<C>
watch -n 1 cat cron_output.log
```