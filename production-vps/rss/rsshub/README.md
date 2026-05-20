# RSSHub Deployment

RSSHub generates RSS feeds for sites that do not expose feeds directly. This
VPS deployment uses the Chromium-bundled RSSHub image and Redis for caching.

## Files

| File | Purpose |
| --- | --- |
| `.env.example` | Compose settings and safe env-file path defaults. |
| `key.env.example` | Production route credential template. |
| `test-key.env.example` | Local/test route credential template. |
| `compose.base.yml` | RSSHub app, Redis cache, private network, and volume. |
| `compose.local.yml` | Local debug env and test credential file. |
| `compose.prod.yml` | Warp proxy setting and `rss-global-network` attachment. |
| `justfile` | Service operations. |

## Environment setup

```sh
cp .env.example .env
cp key.env.example key.env
cp test-key.env.example test-key.env
```

Keep `RSSHUB_KEY_ENV_FILE=key.env` and
`RSSHUB_TEST_KEY_ENV_FILE=test-key.env` in the real `.env` on the VPS. Fill only
the route credentials you need. Real `key.env` and `test-key.env` files are
ignored because route cookies and API tokens are secret-like.

## Network, ports, and data

- Container: `rsshub-app-bundled`.
- Stable hostname: `rsshub-app` for TTRSS subscriptions on
  `rss-global-network`.
- Local/direct host port: `3900` to container port `1200`.
- Private network: `rsshub-defnet`.
- Production RSS group network: `rss-global-network`.
- Redis volume: `rsshub-redis-data`.

Production sets `PROXY_URI=socks5h://warp-proxy:1080` by default so selected
routes can egress through Warp.

## Operations

```sh
just --justfile production-vps/rss/rsshub/justfile --list
just --justfile production-vps/rss/rsshub/justfile config env=prod
just --justfile production-vps/rss/rsshub/justfile boot env=prod
just --justfile production-vps/rss/rsshub/justfile down env=prod
```

Do not run boot/down recipes unless you intend to change live VPS containers.

## Notes

- Keep `PIXIV_BYPASS_CDN=0`; the previous setup found that Pixiv should not
  skip the CDN.
- Discuz route cookies belong in `key.env` and should use the format documented
  in `../notes.md`.
