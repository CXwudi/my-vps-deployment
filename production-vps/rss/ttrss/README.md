# Tiny Tiny RSS Deployment

This service runs Tiny Tiny RSS with PostgreSQL, Mercury Parser, and OpenCC. It
is the primary RSS reader on the VPS.

## Files

| File | Purpose |
| --- | --- |
| `.env.example` | Safe template for database, URL, port, and plugin settings. |
| `compose.base.yml` | TTRSS app, PostgreSQL, Mercury, OpenCC, networks, and volumes. |
| `compose.local.yml` | Local host port and local `SELF_URL_PATH`. |
| `compose.prod.yml` | Production URL and reverse-proxy/RSS networks. |
| `docker-entrypoint.sh` | Local entrypoint patch for allowed ports and feed logging. |
| `justfile` | Service operations. |

## Environment setup

```sh
cp .env.example .env
```

Update `TTRSS_DB_PASS` in `.env` before first boot. The real `.env` file is
ignored.

## Network, ports, and data

- App container: `ttrss-app`.
- Database container: `ttrss-postgres`.
- Helper containers: `ttrss-mercury`, `ttrss-opencc`.
- Local/direct host port: `3901` to app port `80`.
- Production URL: `https://rss.mikufancx.cyou`.
- Private network: `ttrss-defnet`.
- Production networks: `http-global-network` and `rss-global-network`.
- Volumes:
  - `ttrss-postgres-data` for PostgreSQL data.
  - `ttrss-feed-icons` for cached feed icons.
  - `ttrss-plugins` for local plugins.

## Operations

```sh
just --justfile production-vps/rss/ttrss/justfile --list
just --justfile production-vps/rss/ttrss/justfile config env=prod
just --justfile production-vps/rss/ttrss/justfile boot env=prod
just --justfile production-vps/rss/ttrss/justfile down env=prod
```

Do not run boot/down recipes unless you intend to change live VPS containers.

## Plugin workaround

The old setup found that installing plugins through the TTRSS UI was unreliable.
Use the workaround preserved in `../notes.md`: clone the plugin into runtime
`plugins.local`, verify the class name from `init.php`, rename the folder to the
lower-case class name, and mount only the needed plugin folder.

Do not mount all of `/var/www` or `/var/www/plugins.local`; that hides files
provided by the image.

## Browser note

If TTRSS shows `Cannot read property 'forEach' of undefined`, test in incognito
mode or another browser. Some browser extensions/userscripts can trigger it.
