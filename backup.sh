#!/usr/bin/env sh
set -euxo

DB_PORT=${DB_PORT:-3306}

echo "backup: starting backup script"

/usr/bin/mysqldump -u"${DB_USER}" -p"${DB_PASSWORD}" \
  --databases "${DB_DATABASE}" \
  --host "${DB_HOST}" --port "${DB_PORT}" \
  --single-transaction --quick --skip-lock-tables \
  --no-create-db --disable-keys --extended-insert 2>>/dev/stdout > "/home/backup/${DB_DATABASE}.sql"

ret=$?
if [ $ret -eq 0 ]; then
    echo "backup: backup written in /home/backup/${DB_DATABASE}.sql"
else
    echo "backup: backup NOT PERFOMED, mysqldump exit code ${ret}"
fi

