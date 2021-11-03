# Mysql/MariaDB scheduled backups

[![CI](https://github.com/OneOffTech/database-backup-cron/actions/workflows/ci.yml/badge.svg)](https://github.com/OneOffTech/database-backup-cron/actions/workflows/ci.yml)
[![Build Docker Image](https://github.com/OneOffTech/database-backup-cron/actions/workflows/docker.yml/badge.svg)](https://github.com/OneOffTech/database-backup-cron/actions/workflows/docker.yml)

The _database backup cron_ helps creating database dumps (or backups) at regular interval.
Behind the scenes uses `cron` to schedule the execution of `mysqldump`.

It is designed to run in Docker containers in parallel to a MariaDB or MySQL container.
As of now it can only backup a single database at a time.

## Getting started

The best way run it is with Docker Compose:

```yaml
  backup:
    image: oneofftech/database-backup-cron:latest
    environment:
      DB_HOST: "### Replace With Database Host ###"
      DB_DATABASE: "### Replace With Database Name ###"
      DB_USER: "### Replace With Database User ###"
      DB_PASSWORD: "### Replace With Database Password ###"
    volumes: 
      - "/home/backup/backups"
```

> Don't forget to add the database as a dependant service and place it in the 
same network of your MariaDB/MySQL container. An example 
[docker-compose.yml](./docker-compose.yml) is available.

> Using `latest` tag for Docker image, consider using the 
[latest tagged release](https://github.com/OneOffTech/database-backup-cron/releases).

As shown in the code block above is required to specify some configuration
parameter before running the service, in particular how to connect to your 
database:

- `DB_HOST`: The host on which the MariaDB\MySQL instance is running
- `DB_DATABASE`: The name of the database to backup
- `DB_USER`: The user that can access the database
- `DB_PASSWORD`: The password to access the database

The database dump will be created at 11.02pm each day 
in the `/home/backup/backups/` folder. Filename will be `{DB_DATABASE}.sql`.

> The backup schedule is [configurable](#backup-schedule), 11.02pm is just a default value.

### Configuration

#### database connection

Database connection is configured using the following environment variables:

- `DB_HOST`: The host on which the MariaDB\MySQL instance is running
- `DB_PORT`: Default `3306`. The port on which the MariaDB\MySQL instance is listening
- `DB_DATABASE`: The name of the database to backup
- `DB_USER`: The user that can access the database
- `DB_PASSWORD`: The password to access the database

#### backup schedule

The backup trigger can be configured. By default it is configured to
run daily at 11.02pm UTC.

If you want you can change the schedule by specifying a 
_cron schedule expression_ using the `CRON_SCHEDULE`
environment variable. For example you can run it 
every minute `CRON_SCHEDULE: "* * * * *"` or shift it closer 
to midnight `CRON_SCHEDULE: "57 23 * * *"`.

If you need more complex scheduling head over to https://crontab.guru/
for examples and a nice expression editor.


#### cron options

Some cron options are configurable:

- `CRON_LOG_LEVEL`, change the logging level of the cron deamon (default `2`).

