# VPS Infrastructure Services

This folder contains host-scoped infrastructure services for the lightweight VPS.

| Path | Purpose |
| --- | --- |
| `watchtower/` | Container image update automation. |
| `docker-volume-backup/` | Scheduled Docker volume backups to local archive and S3-compatible storage. |
| `backup-files/` | Ignored local backup archive output. |

## Operations

Use the host-level recipes for grouped infrastructure operations. The old infra shell-script shims were removed:

```sh
just --justfile production-vps/justfile boot-infra
just --justfile production-vps/justfile down-infra
```

Use service-level justfiles for config rendering and service-specific actions:

```sh
just --justfile production-vps/infra/watchtower/justfile --list
just --justfile production-vps/infra/docker-volume-backup/justfile --list
```

Do not start backup jobs or update automation during migration verification.
