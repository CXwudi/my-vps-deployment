# Deployment of My Lightweight VPS Server

This folder contains the Docker Compose deployments and operational wrappers for
the lightweight production VPS host.

## Required tools

- Docker Engine
- Docker Compose plugin
- [Just](https://github.com/casey/just)

Install service-specific tools only when a service README asks for them. Normal
operations should be discoverable from this README and from `just --list`.

## Host layout

| Path | Purpose |
| --- | --- |
| `LLMs/` | LLM-facing services such as LobeChat and the shared LLM network helpers. |
| `rss/` | RSSHub, Tiny Tiny RSS, WeWe RSS, and RSS group orchestration. |
| `nginx/` | Public reverse proxy configuration for HTTPS entry points. |
| `fake-site-entry/` | Static/internal entry used by reverse-proxy rules. |
| `certification/` | Certificate copy helper and certificate mount documentation. Runtime certs stay out of Git. |
| `infra/` | Host infrastructure services such as Watchtower and Docker volume backup. |
| `lego/` | ACME certificate issuance and renewal tooling. ACME account state stays out of Git. |
| `youcal/` | Scheduled one-shot calendar generation job. |
| `sing-box/` | Host-network proxy service with TUN support. |
| `warp/` | Cloudflare WARP network-proxy helper. |

Read the README inside a service folder before operating that service.

## Network model

Most public services join the external Docker bridge network
`http-global-network`. Nginx is the public reverse-proxy entry point and routes
to services on this shared network.

Create or remove the network through the host `justfile`:

```sh
just --justfile production-vps/justfile create-net
just --justfile production-vps/justfile remove-net
```

Sing-box and Warp are documented exceptions. They use host/network-proxy
behavior and should not be forced onto the normal reverse-proxy model.

## Host-level operations

List available host recipes without changing live services:

```sh
just --justfile production-vps/justfile --list
```

Important recipes:

| Recipe | Purpose |
| --- | --- |
| `create-net` | Create `http-global-network`. |
| `remove-net` | Remove `http-global-network`. |
| `boot-infra` / `down-infra` | Compatibility wrappers for the legacy infra scripts. |
| `boot-all` / `down-all` / `reboot-all` | Operate known long-running service groups. These alter live Docker services. |

Legacy shell-script shims for these host operations were removed after the
`justfile` became the stable entry point.

Do not run boot, down, or reboot recipes unless you intend to change live VPS
services.

## Safety expectations

- Real `.env` files, provider keys, certificates, ACME state, htpasswd files,
  logs, backup archives, generated state, and bundled binaries are ignored.
- Track `.env.example` files and documentation instead of real credentials.
- Keep service-specific exceptions documented in that service's README.
- Do not push local checkpoint commits during the migration workflow.
