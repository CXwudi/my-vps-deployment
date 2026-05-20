# My VPS Deployment

Monorepo for Docker-based deployments across three hosts:
power server, lightweight VPS, and local Debian server.

## Repository Layout

| Directory | Host | Description |
|---|---|---|
| `production-power-server/` | Power Server (main) | Primary services: n8n, Dify, nginx |
| `production-vps/` | Lightweight VPS | LobeChat, RSS, sing-box, youcal, lego |
| `production-local-debian/` | Local Debian | qBittorrent, AdGuard Home, Cloudflare Tunnel, OpenList |
| `common-doc/` | Shared | Deployment standards and shared documentation |

## Getting Started

1. Read `common-doc/README.md` for documentation conventions.
2. Read the host `README.md` for host-specific setup.
3. Each service follows the deployment standard in
   `common-doc/service-deployment-standard.md`.

## Safety

- **Never** commit `.env` files containing real credentials.
- **Never** commit certificates, private keys, or ACME account data.
- **Never** commit backup archives, logs, or runtime state.
- Use `.env.example` files for documenting required environment variables.
- `spec/` and `plan/` directories are temporary planning artifacts — they are
  ignored by Git.

## Stack

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Just](https://github.com/casey/just)
