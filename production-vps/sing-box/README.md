# Sing-box

Sing-box is a VPS network proxy service. It is intentionally not shaped like a
normal reverse-proxied web service.

## Why host networking is required

`compose.yml` uses:

- `network_mode: host`
- `/dev/net/tun`
- `NET_ADMIN`

These settings are required for the existing proxy/TUN behavior and full-cone NAT
requirements. Do not remove them just to match the standard reverse-proxy
service shape.

## Configuration and secrets

Tracked config files under `conf/` contain only non-secret common settings. The
Trojan inbound contains passwords and a websocket path, so it is represented by a
tracked template:

```sh
cp conf/trojan-inbounds.secret.json.example conf/trojan-inbounds.secret.json
```

Edit `conf/trojan-inbounds.secret.json` on the VPS with real passwords. The real
`*secret*.json` file is ignored.

The mixed inbound in `common_inbounds.json` listens on port `1080` for local VPS
services such as RSSHub.

Logs are written to `logs/`, which is ignored.

## Warp interaction

Sing-box runs with host networking. Its `warp-out` outbound points at
`127.0.0.1:3902`, which is the host-published SOCKS port from the Warp service.
This is why Warp publishes `3902:1080` instead of relying only on Docker DNS.

## Operations

```sh
just --justfile production-vps/sing-box/justfile --list
just --justfile production-vps/sing-box/justfile config
just --justfile production-vps/sing-box/justfile boot
just --justfile production-vps/sing-box/justfile down
```

Boot/down recipes change live proxy networking on the VPS.
