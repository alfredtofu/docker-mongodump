#!/bin/bash

set -eo pipefail

echo "Job started: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)

cmd="mongodump --uri \"$MONGO_URI\" --gzip"
if [[ "$MONGO_COLLECTION" ]]; then
    cmd="$cmd -c \"$MONGO_COLLECTION\""
fi
echo "run command: $cmd"


FILE="$TARGET_FOLDER/backup-$DATE.tar.gz"

mkdir -p "$TARGET_FOLDER"
$cmd --archive="$FILE"
echo "Mongo dump saved to $FILE"

echo "Job finished: $(date)"
