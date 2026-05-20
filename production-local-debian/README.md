# Deployment of My Local Debian Server

Local-network Docker server providing DNS (AdGuard Home), reverse proxy
(nginx), Cloudflare Tunnel, OpenList, and qBittorrent.

## Stack

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Just](https://github.com/casey/just)

## Host Layout

| Directory | Service | Role |
|---|---|---|
| `adguardhome/` | AdGuard Home | Local DNS + ad blocking |
| `cloudflare-tunnel/` | Cloudflare Tunnel | Public access without port forwarding |
| `infra/watchtower/` | Watchtower | Auto-update Docker containers |
| `nginx/` | Nginx | Local reverse proxy |
| `openlist/` | OpenList | Shared to-do / checklists |
| `qbittorrent/` | qBittorrent + PeerBanHelper + add-tracker | Torrent downloads |

## Network Model

All services connect through a shared `global-net` bridge network, managed via:

```bash
just create-net     # docker network create --driver bridge global-net
just shutdown-net   # docker network rm global-net
```

Services not using the global network (e.g., AdGuard Home with host DNS ports,
Cloudflare Tunnel) are documented in their respective READMEs.

## Operational Entry Points

```bash
# Host-level
just --list                # List all host recipes
just create-net            # Create global network
just shutdown-net          # Remove global network
just boot-all              # Start all services
just down-all              # Stop all services

# Individual services
just boot-openlist         # Start OpenList (prod)
just boot-qbittorrent      # Start qBittorrent (prod)
just boot-adguardhome      # Start AdGuard Home
just boot-cloudflare-tunnel # Start Cloudflare Tunnel (prod)
just boot-nginx            # Start nginx
just boot-watchtower       # Start Watchtower
```

## Port Assignments

See `ports.csv` for the full port inventory.

## Cron Jobs

See `crontab.txt` for scheduled tasks (qBittorrent reboot workaround).
Installation is manual — do not edit the live crontab from this repository.
