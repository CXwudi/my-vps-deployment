# Docker Volume Backup

This service runs `offen/docker-volume-backup` to back up selected external
Docker volumes to local archives and S3-compatible storage.

## Tracked and ignored files

| Path | Policy |
| --- | --- |
| `compose.yml` | Tracked service definition. |
| `.env.example` | Tracked safe template. |
| `README.md`, `justfile` | Tracked docs and operations. |
| `.env`, `default.env`, `global.env` | Ignored runtime env files; may contain S3 and notification secrets. |
| `config/`, `disabled/` | Ignored runtime backup job env files. |
| `../backup-files/` | Ignored backup archive output. |

## Required external volumes

The following Docker volumes must already exist before the backup service starts:

- `ttrss-postgres-data`
- `rsshub-redis-data`
- `lobechat-db`

The LobeChat variable names still use `PGVECTOR` in places because the earlier
backup config used that name. The actual current Docker volume is `lobechat-db`.

## Environment setup

Copy the safe template on the VPS:

```sh
cp .env.example .env
```

If you want to consolidate the old `default.env` and `global.env` into `.env`,
set these values in `.env`:

```dotenv
DOCKER_VOLUME_BACKUP_DEFAULT_ENV_FILE=.env
DOCKER_VOLUME_BACKUP_GLOBAL_ENV_FILE=.env
```

Fill real S3-compatible storage credentials and notification URLs only in the
ignored runtime env file. Do not commit `default.env`, `global.env`, or files
under `config/`.

## Backup jobs

Runtime job files under `config/` define the concrete schedules, source paths,
filenames, pruning prefixes, retention, and stop-during-backup labels. They are
ignored because they are environment-specific and may reveal storage policy.

The Compose service mounts `config/` read-only at
`/etc/dockervolumebackup/conf.d`.

## Operations

```sh
just --justfile production-vps/infra/docker-volume-backup/justfile --list
just --justfile production-vps/infra/docker-volume-backup/justfile config
just --justfile production-vps/infra/docker-volume-backup/justfile boot
just --justfile production-vps/infra/docker-volume-backup/justfile down
```

Boot/down recipes change live infrastructure containers. There is no safe dry
run recipe in this wrapper; use `config` for render validation and `logs` for
read-only inspection.
