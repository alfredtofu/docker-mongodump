#!/bin/bash

set -e

export MONGO_URI=${MONGO_URI:-mongodb://mongo:27017}
export TARGET_FOLDER=${TARGET_FOLDER-/backup}   # can be set to null

# Optional env vars:
# - CRON_SCHEDULE
# - TARGET_S3_FOLDER
# - AWS_ACCESS_KEY_ID
# - AWS_SECRET_ACCESS_KEY
mkdir -p ${TARGET_FOLDER}

if [[ "$CRON_SCHEDULE" ]]; then
    LOGFIFO='/var/log/cron.fifo'
    if [[ ! -e "$LOGFIFO" ]]; then
        mkfifo "$LOGFIFO"
    fi
    CRON_ENV="MONGO_URI='$MONGO_URI'"
    if [[ "$MONGO_COLLECTION" ]]; then
        CRON_ENV="$CRON_ENV\nMONGO_COLLECTION='$MONGO_COLLECTION'"
    fi
    echo -e "$CRON_ENV\n$CRON_SCHEDULE /backup.sh > $LOGFIFO 2>&1" | crontab -
    crontab -l
    cron
    tail -f "$LOGFIFO"
else
    exec /backup.sh
fi
