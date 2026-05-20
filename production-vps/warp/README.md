# Cloudflare Warp Proxy

Warp provides a SOCKS proxy on the VPS for traffic that should exit through
Cloudflare WARP. RSSHub and Sing-box can use it for sites that block VPS IPs.

## Environment setup

`compose.yml` defaults to `.env.example` so config rendering does not require a
real license. On the VPS, copy the template if you use a Warp license:

```sh
cp .env.example .env
```

Then set this in `.env`:

```dotenv
WARP_ENV_FILE=.env
WARP_LICENSE=<optional-warp-license>
```

The real `.env` is ignored.

## Networking model

- Container: `warp-proxy`.
- Container SOCKS port: `1080`.
- Host-published SOCKS port: `3902`.
- Private network: `warp-defnet`.
- Reverse-proxy/global network: `http-global-network` for Docker DNS access from
  other normal containers.

Sing-box uses host networking, so it reaches Warp through `127.0.0.1:3902` on
the host. Normal Docker-networked services can use `socks5h://warp-proxy:1080`
when attached to a shared network with Warp.

## Operations

```sh
just --justfile production-vps/warp/justfile --list
just --justfile production-vps/warp/justfile config
just --justfile production-vps/warp/justfile boot
just --justfile production-vps/warp/justfile down
```

A debug curl profile is available as `just test`, but it starts a one-shot
container and performs a network request.
