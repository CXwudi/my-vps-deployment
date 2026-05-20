# VPS RSS Services

This folder contains the RSS service group for the lightweight VPS:

- RSSHub for route-based feed generation.
- Tiny Tiny RSS for feed reading and aggregation.
- WeWe RSS for WeChat public-account feeds.

Read each service README before operating that service.

## Network model

| Network | Purpose |
| --- | --- |
| `rss-global-network` | Private cross-service network for RSSHub, TTRSS, and WeWe RSS. |
| `http-global-network` | Host-level reverse-proxy network used by nginx in production. |

RSSHub keeps the hostname `rsshub-app` because existing TTRSS subscriptions may
refer to `http://rsshub-app` through `rss-global-network`.

## Group operations

List group recipes:

```sh
just --justfile production-vps/rss/justfile --list
```

Render all service configs without starting containers:

```sh
just --justfile production-vps/rss/justfile config env=prod
just --justfile production-vps/rss/justfile config env=local
```

Boot or stop all RSS services:

```sh
just --justfile production-vps/rss/justfile boot-all env=prod
just --justfile production-vps/rss/justfile down-all env=prod
```

The group `boot`/`down` recipes create and remove `rss-global-network` as
needed. They alter live Docker services, so do not run them during migration
verification.

## Service ports and URLs

| Service | Local URL/port | Production URL/port |
| --- | --- | --- |
| RSSHub | `http://localhost:3900` | Direct host port `3900`; usually consumed by TTRSS/nginx. |
| TTRSS | `http://localhost:3901` | `https://rss.mikufancx.cyou` and host port `3901`. |
| WeWe RSS | `http://localhost:4000` | `https://rss.mikufancx.cyou` through nginx path/routing rules. |

## Secrets and runtime state

- Real `.env`, `key.env`, and `test-key.env` files are ignored.
- Track only `.env.example`, `key.env.example`, and `test-key.env.example`.
- Redis, PostgreSQL, plugins, feed icons, and SQLite data live in Docker named
  volumes and are not committed.
- SQL dumps and backup archives are ignored.

See `notes.md` for preserved operational observations from the existing setup.
