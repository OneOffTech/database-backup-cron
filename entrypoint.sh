#!/usr/bin/env sh
set -euxo

CRON_SCHEDULE=${CRON_SCHEDULE:-"2 23 * * *"}
CRON_LOG_LEVEL=${CRON_LOG_LEVEL:-2}

# TODO: check if required variables ${DB_USER} ${DB_PASSWORD} ${DB_DATABASE} ${DB_HOST} are configured

chown -R backup /opt/backup && \
echo "${CRON_SCHEDULE} /opt/backup.sh >> /dev/stdout 2>&1" > /var/spool/cron/crontabs/root && \
crond -f -l "${CRON_LOG_LEVEL}" -d "${CRON_LOG_LEVEL}" -L /dev/stdout
