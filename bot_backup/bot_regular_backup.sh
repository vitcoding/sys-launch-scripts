#!/bin/bash

# Load environment variables
source "$HOME/sh/bot_backup/.env.remote" || {
    echo "$(date '+%Y%m%d_%H%M'): Error: Failed to load .env.remote" >&2
    exit 1
}

# Execute remote commands via SSH (without -t for pseudo-terminal)
ssh_exit_code=0
ssh -p "$REMOTE_PORT" -i "$SSH_KEY" "$REMOTE_USER@$REMOTE_HOST" "
    cd '$REMOTE_BOT_DIR' || exit 1
    pwd
    rm -rf ./_temp/backups/last_regular || exit 1
    # tree -L 4
    chmod +x ./sh/regular_backup/regular_backup.sh
    ./sh/regular_backup/regular_backup.sh || exit 1
    # tree -L 4
" || ssh_exit_code=$?

# Check if SSH command failed
if [ "$ssh_exit_code" -ne 0 ]; then
    echo "$(date '+%Y%m%d_%H%M'): SSH command failed (exit code $ssh_exit_code)" >&2
    exit "$ssh_exit_code"
fi

# Create local backup directory with timestamp
mkdir -p "$LOCAL_REGULAR_BACKUP_DIR/$(date '+%Y%m%d_%H%M')" || exit 1

# Copy backup files from remote to local
scp -i "$SSH_KEY" -P "$REMOTE_PORT" \
    -o "BatchMode=yes" \
    -o "StrictHostKeyChecking=no" \
    -r "$REMOTE_USER@$REMOTE_HOST:$REMOTE_LAST_REGULAR_BACKUP_DIR/"* \
    "$LOCAL_REGULAR_BACKUP_DIR/$(date '+%Y%m%d_%H%M')/" || {
    echo "$(date '+%Y%m%d_%H%M'): SCP copy failed" >&2
    exit 1
}

echo "$(date '+%Y%m%d_%H%M'): Backup completed successfully" >> /dev/stdout
exit 0