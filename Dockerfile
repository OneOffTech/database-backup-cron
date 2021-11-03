FROM alpine:3.14.2

ARG BUILD_DATE
ARG BUILD_COMMIT

LABEL maintainer="OneOffTech <info@oneofftech.xyz>" \
  org.label-schema.name="oneofftech/database-backup-cron" \
  org.label-schema.description="Docker image for scheduling MariaDB/Mysql database backups" \
  org.label-schema.schema-version="1.0" \
  org.label-schema.vcs-url="https://github.com/oneofftech/database-backup-cron"

RUN addgroup -S backup && adduser -D -H -G backup backup

RUN apk add --no-cache --update busybox-suid mysql-client libcap && \
    setcap cap_setgid=ep /bin/busybox

COPY --chown=backup:backup *.sh /opt/

RUN rm -f /var/spool/cron/crontabs/root && \
    chmod +x /opt/entrypoint.sh && \
    chmod +x /opt/backup.sh && \
    mkdir /var/log/cron/ && \
    mkdir -p /home/backup/backups && \
    chown -R backup:backup /home/backup && \
    chown -R backup:backup /var/log/cron/ && \
    touch /var/spool/cron/crontabs/backup && \
    chgrp backup /var/spool/cron/crontabs/backup && \
    chmod g+rw /var/spool/cron/crontabs/backup

USER backup

VOLUME /home/backup/backups

ENTRYPOINT ["/opt/entrypoint.sh"]

LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$BUILD_COMMIT
