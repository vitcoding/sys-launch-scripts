#!/bin/bash

source "$HOME/sh/bot_backup/.env.remote"

ssh -p "$REMOTE_PORT" -i "$SSH_KEY" -t "$REMOTE_USER@$REMOTE_HOST" "
    cd "$REMOTE_BOT_DIR";
    pwd;
    rm -rf ./_temp/backups/last_regular;
    tree -L 4;
    chmod +x ./sh/regular_backup/regular_backup.sh;
    ./sh/regular_backup/regular_backup.sh;
    tree -L 4;
"

scp -r "$REMOTE_USER@$REMOTE_HOST":"$REMOTE_LAST_REGULAR_BACKUP_DIR"/* "$LOCAL_REGULAR_BACKUP_DIR"/$(date '+%Y%m%d_%H%M')