#!/bin/bash

declare -p | grep -Ev 'BASHOPTS|BASH_VERSINFO|EUID|PPID|SHELLOPTS|UID' > /container.env

# Setup a cron schedule
echo "SHELL=/bin/bash
BASH_ENV=/container.env
0 4 * * * /home/ubuntu/backup.sh
# This extra line makes it a valid cron" > scheduler.txt

crontab scheduler.txt


