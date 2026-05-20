# qBittorrent + PeerBanHelper + Add-Trackers

Torrent download stack for the local Debian server.

- **qBittorrent Web UI**: http://localhost:3902
- **PeerBanHelper Web UI**: http://localhost:3903
- **Add-Trackers helper**: internal only (port 8080 by default)

## Setup

1. Copy `.env.example` to `.env` and set `QBITTORRENT_PASSWORD`.
   **Rotate this password** if the previous value was ever hardcoded or exposed.
2. Start: `just boot env=prod`
3. Stop: `just down env=prod`

## Recipes

| Command | Description |
|---|---|
| `just boot env=prod` | Start all three services |
| `just down env=prod` | Stop all services |
| `just reboot env=prod` | Restart all services |
| `just config env=prod` | Render resolved compose config |
| `just backup` | Backup volumes to `./backup/` |
| `just restore` | Restore volumes from `./backup/` |
| `just reboot-qb` | Reboot qbittorrent-app only (memory leak workaround) |

## Volumes

| Volume | Purpose |
|---|---|
| `qbittorrent-config` | qBittorrent app config |
| `peerbanhelper-data` | PeerBanHelper state |
| `../torrent-download` (bind mount) | Downloaded torrents at `/downloads` |

## Ports

| Port | Service |
|---|---|
| 3902 | qBittorrent Web UI |
| 39001 | BitTorrent traffic (TCP+UDP) |
| 3903 | PeerBanHelper Web UI |

## Networking

Services connect via `qbittorrent-defnet` and attach to `global-net` in
production. The add-trackers helper connects to qBittorrent internally at
`http://qbittorrent-app:<WEBUI_PORT>`.

## Memory Leak Workaround

qBittorrent with libtorrent 2.0.x may leak memory over time. A scheduled
`just reboot-qb` (via `crontab.txt`) stops, removes, and recreates only the
`qbittorrent-app` container without touching data volumes. See
[libtorrent#6667](https://github.com/arvidn/libtorrent/issues/6667).

## Backup / Restore

Backups are stored in `./backup/` (gitignored). The backup recipe creates
temporary containers, archives volumes, and cleans up. Restore reverses the
process.

## Cron

```cron
0 1,11 * * * PWD=/path/to/qbittorrent just reboot-qb
```

Installation is manual — do not edit the live crontab from this repository.
