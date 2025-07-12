## service
```bash
sudo nano /etc/systemd/system/bot_backup.service
```

```ini
[Unit]
Description=Run bot backup script

[Service]
Type=simple
ExecStart=/home/<user>/sh/bot_backup/bot_regular_backup.sh
User=<user>
WorkingDirectory=/home/<user>/sh/bot_backup/
StandardOutput=file:/home/<user>/sh/bot_backup/backup.log
StandardError=inherit

```

## timer
```bash
sudo nano /etc/systemd/system/bot_backup.timer
```

```ini
[Unit]
Description=Run bot_backup daily

[Timer]
Unit=bot_backup.service
OnCalendar=daily    # Daily at 00:00:00
AccuracySec=1h      # Starting with an error of ± 1 hour (to save energy)
Persistent=true     # If the PC was turned off, it will complete the task when turned on.
OnBootSec=1m
OnStartupSec=1m

[Install]
WantedBy=timers.target
```

## start
```bash
sudo systemctl enable --now bot_backup.timer  # Enable autorun
sudo systemctl start bot_backup.timer         # Launch immediately
```

## check status
```bash
systemctl list-timers --all
systemctl status bot_backup.timer
journalctl -u bot_backup.service # logs
###
journalctl -u bot_backup.service -f  # real time logs
journalctl -u bot_backup.service --since "2024-01-01" --until "2024-01-02"
```

---
## Other Timer Examples
Example 1: Run every 6 hours
```ini
[Timer]
OnCalendar=*-*-* 0/6:00:00     # Every 6 hours (00:00, 06:00, 12:00, 18:00)
RandomizedDelaySec=30m          # Random delay (up to 30 minutes)
```

Example 2: Run every 30 minutes
```ini
[Timer]
OnCalendar=*-*-* *:0/30:00     # Every 30 minutes (:00, :30)
```

Example 3: Run on boot + once daily
```ini
[Timer]
OnBootSec=15min                 # 15 minutes after boot
OnUnitActiveSec=1d              # Once per day after last run
```

Example 4: Exact time (cron-like)
```ini
[Timer]
OnCalendar=Mon,Fri 03:30:00    # Every Monday and Friday at 3:30 AM
```

