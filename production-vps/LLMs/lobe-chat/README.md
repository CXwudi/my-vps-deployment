# LobeChat Deployment

This service runs LobeChat with PostgreSQL/ParadeDB, Redis, and a private
SearXNG instance on the lightweight VPS.

## Prerequisites

- Docker Engine
- Docker Compose plugin
- `just`
- Host-level `http-global-network` for production reverse-proxy access

## Files

| File | Purpose |
| --- | --- |
| `.env.example` | Safe runtime configuration template. Copy to `.env` on the VPS. |
| `../all-llm-keys.env.example` | Safe shared LLM provider-key template. |
| `compose.base.yml` | Common LobeChat, database, Redis, and SearXNG services. |
| `compose.local.yml` | Local ports and local `APP_URL`. |
| `compose.prod.yml` | Production `APP_URL` and external nginx network attachment. |
| `justfile` | Operational recipes for boot, down, config, update, backup, and restore. |

## Environment setup

1. Copy the service template:

   ```sh
   cp .env.example .env
   ```

2. Copy the shared provider-key template from `production-vps/LLMs/`:

   ```sh
   cp ../all-llm-keys.env.example ../all-llm-keys.env
   ```

3. Fill `.env` with service secrets and set:

   ```dotenv
   LLM_KEYS_ENV_FILE=../all-llm-keys.env
   ```

4. Fill only the providers you use in `../all-llm-keys.env`.

The real `.env` and `../all-llm-keys.env` files are ignored. Do not commit real
provider keys, auth secrets, database passwords, or S3 credentials.

## Networks and volumes

- Private network: `lobechat-defnet`.
- Production reverse-proxy network: `http-global-network` through the `nginx`
  network alias in `compose.prod.yml`.
- Named volumes:
  - `lobechat-db` for PostgreSQL/ParadeDB data.
  - `lobechat-redis` for Redis append-only data.
  - `lobechat-searxng-data` for SearXNG settings.

The older `llm-http-global-network` helper in `../justfile` is not required by
this LobeChat stack. It is kept for compatibility with older/disabled LLM
services.

## Operations

List recipes:

```sh
just --justfile production-vps/LLMs/lobe-chat/justfile --list
```

Render config without starting containers:

```sh
just --justfile production-vps/LLMs/lobe-chat/justfile config env=prod
just --justfile production-vps/LLMs/lobe-chat/justfile config env=local
```

Boot or stop production:

```sh
just --justfile production-vps/LLMs/lobe-chat/justfile boot env=prod
just --justfile production-vps/LLMs/lobe-chat/justfile down env=prod
```

Boot local testing:

```sh
just --justfile production-vps/LLMs/lobe-chat/justfile boot env=local
```

Update production images and restart:

```sh
just --justfile production-vps/LLMs/lobe-chat/justfile update env=prod
```

The update recipe pulls images, reboots the stack, and prunes unused images. It
does not prune Docker volumes or networks.

## Backup and restore

The `backup` and `restore` recipes operate named Docker volumes by creating
containers and copying volume contents. They change live service state, so run
them only during a planned maintenance window.

The infrastructure backup service also uses labels on `lobechat-db` and
`lobechat-redis` to stop containers during scheduled backups.

## SearXNG note

If SearXNG search is enabled, ensure SearXNG JSON responses are enabled in its
runtime configuration after first boot.
