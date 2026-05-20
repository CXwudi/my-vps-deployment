# Cloudflare Tunnel

Provides public access to local Debian services without port forwarding, via
Cloudflare's Tunnel (cloudflared).

## Setup

1. Copy `.env.example` to `.env` and set `CF_TUNNEL_TOKEN`.
   Obtain the token from **Cloudflare Zero Trust > Access > Tunnels**.
2. Start in production: `just boot env=prod`
3. Start in debug (no global-net): `just boot-debug`
4. Stop: `just down env=prod`

## Recipes

| Command | Description |
|---|---|
| `just boot env=prod` | Start with global-net |
| `just boot-debug` | Start tunnel only (connectivity test) |
| `just down env=prod` | Stop production |
| `just down-debug` | Stop debug |
| `just reboot env=prod` | Restart production |
| `just config env=prod` | Render resolved compose config |

## Modes

- **Debug** (`just boot-debug`): Starts only the tunnel container on
  `cloudflare-tunnel-defnet`. No reverse-proxy access. Useful for testing
  tunnel connectivity.
- **Production** (`just boot env=prod`): Starts tunnel + attaches to
  `global-net` so it can reach nginx and other reverse-proxied services.

## Networking

| Mode | Networks |
|---|---|
| Debug | `cloudflare-tunnel-defnet` |
| Production | `cloudflare-tunnel-defnet` + `global-net` |

## Notes

- The `--no-autoupdate` flag prevents cloudflared from self-updating inside the
  container (the image is updated via Watchtower instead).
- The `test` profile in `compose.base.yml` provides a debug nginx container if
  needed for connectivity testing.
- The tunnel token is sensitive — never commit it to Git.
