#!/bin/bash

set -eo pipefail

echo "Job started: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)

cmd="mongodump --uri \"$MONGO_URI\" --gzip"
if [[ "$MONGO_COLLECTION" ]]; then
    cmd="$cmd -c \"$MONGO_COLLECTION\""
fi
echo "run command: $cmd"


TARGET_FOLDER="/backup/$DATE"

mkdir -p "$TARGET_FOLDER"
$cmd -o $TARGET_FOLDER
echo "Mongo dump saved to $TARGET_FOLDER"

echo "Job finished: $(date)"
