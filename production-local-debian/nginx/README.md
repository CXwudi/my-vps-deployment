# Nginx — Local Reverse Proxy

Reverse proxy for local Debian services. Handles TLS termination using
Let's Encrypt certificates.

- **HTTP**: Port 80
- **HTTPS**: Port 443

## Setup

1. Ensure certificates are in `./certificate/letsencrypt-cert/` (gitignored).
2. Start: `just boot`
3. Stop: `just down`

## Recipes

| Command | Description |
|---|---|
| `just boot` | Start nginx |
| `just down` | Stop nginx |
| `just reboot` | Restart nginx |
| `just config` | Render resolved compose config |
| `just test-config` | Test nginx config syntax |
| `just reload` | Reload nginx without downtime |

## Config Layout

```
config/
├── nginx.conf              # Main nginx config
├── nginxconfig.io/         # Shared config snippets (security, proxy, general)
├── sites-enabled/          # Active site configs
├── sites-disabled/         # Disabled/stale site configs
└── htpasswd/               # Auth files (if any)
```

## Certificates

Certificates live in `./certificate/` (gitignored):
- `letsencrypt-cert/_.mikufancx.cyou.crt`
- `letsencrypt-cert/_.mikufancx.cyou.key`
- `dhparam.pem`

Copy certificates from the VPS using `production-vps/certification/copy-cert.sh`.

## Stale Configs

- `sites-disabled/dify.mikufancx.cyou.conf` — Dify reverse proxy (Dify moved
  to production-power-server).

## Notes

- Nginx attaches to both `nginx-defnet` and `global-net` for access to local
  services and external connectivity.
- Logs are written to `./logs/` (gitignored).
