# WeWe RSS Deployment

WeWe RSS generates feeds for WeChat public-account content. It is a normal
long-running Compose service with SQLite-backed state.

## Files

| File | Purpose |
| --- | --- |
| `.env.example` | Safe template for auth code, URL, schedule, and port settings. |
| `compose.base.yml` | WeWe RSS app, private network, and SQLite volume. |
| `compose.local.yml` | Local host port and local origin URL. |
| `compose.prod.yml` | Production origin URL plus RSS and reverse-proxy networks. |
| `justfile` | Service operations. |
| `note.md` | Preserved rationale for using WeWe RSS. |

## Environment setup

```sh
cp .env.example .env
```

Change `WEWE_RSS_AUTH_CODE` in `.env` before first boot. The real `.env` file is
ignored.

## Network, ports, and data

- Container: `wewe-rss-app`.
- Local host port: `4000`.
- Production origin URL: `https://rss.mikufancx.cyou`.
- Private network: `wewe-rss-defnet`.
- Production networks: `rss-global-network` and `http-global-network`.
- SQLite volume: `wewe-sqlite-data` mounted at `/app/data`.

## Operations

```sh
just --justfile production-vps/rss/wewe-rss/justfile --list
just --justfile production-vps/rss/wewe-rss/justfile config env=prod
just --justfile production-vps/rss/wewe-rss/justfile boot env=prod
just --justfile production-vps/rss/wewe-rss/justfile down env=prod
```

Do not run boot/down recipes unless you intend to change live VPS containers.
