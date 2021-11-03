#!/usr/bin/env sh
set -euo

DB_PORT=${DB_PORT:-3306}

echo "backup: starting backup script"

mysqldump -u${DB_USER} -p${DB_PASSWORD} \
  --databases ${DB_DATABASE} \
  --host ${DB_HOST} --port ${DB_PORT} \
  --single-transaction --quick --skip-lock-tables \
  --no-create-db --disable-keys --extended-insert  > "/home/backup/backups/${DB_DATABASE}.sql"

echo "backup: backup written in /home/backup/backups/${DB_DATABASE}.sql"
