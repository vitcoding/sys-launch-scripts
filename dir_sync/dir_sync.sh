#!/bin/bash

source "/home/$USER/sh/dir_sync/.env.transfer"
dir_path=$1

echo "Syncing: $dir_path"

transfer_dir="$REMOTE_BASE_TRANSFER_DIR"/temp_$(date '+%Y_%m_%d')
mkdir -p "$transfer_dir"

rsync -avz "$dir_path" \
    "$REMOTE_NAME:$transfer_dir"