# AdGuard Home

Local-network DNS and ad-blocking infrastructure. **Not** a reverse-proxied web
app — binds DNS ports directly on the host.

- **Admin Web UI**: http://localhost:3900
- **DNS**: Port 53 (TCP+UDP) on host

## Setup

1. Start: `just boot`
2. Stop: `just down`
3. Configure via Web UI at http://localhost:3900

## State

Configuration and runtime data live in `./adguard/` (gitignored). The directory
is bind-mounted into the container and persists across restarts.

## Recipes

| Command | Description |
|---|---|
| `just boot` | Start AdGuard Home |
| `just down` | Stop AdGuard Home |
| `just reboot` | Restart AdGuard Home |
| `just config` | Render resolved compose config |

## Ports

| Port | Protocol | Purpose |
|---|---|---|
| 53 | TCP+UDP | DNS |
| 3900 | TCP | Admin Web UI |

## Notes

- AdGuard Home binds privileged DNS ports directly on the host. This is
  intentional for local-network DNS resolution.
- Do not change DNS port bindings without ensuring no other DNS server is
  running on the host.
- The DHCP server (ports 67/68) is disabled by default.
