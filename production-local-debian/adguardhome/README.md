# AdGuard Home

Local-network DNS and ad-blocking infrastructure. **Not** a reverse-proxied web
app — binds DNS ports directly on the host.

- **Admin Web UI**: <http://local.ip:3900> (`http://localhost:3900` on the server)
- **DNS**: `local.ip:53` (TCP+UDP)

## Setup

1. Start: `just boot`
2. Stop: `just down`
3. Configure via Web UI at <http://local.ip:3900>.

## LAN DNS

Router such as OpenWrt serves DHCP. Within the existing `config dhcp 'lan'` section, advertise AdGuard Home as the client DNS server:

```text
list dhcp_option '6,local.ip'
```

Clients receive this DNS address when obtaining or renewing their DHCP lease. The local server itself uses the router IP address as its resolver, with NetworkManager's `ipv4.ignore-auto-dns` enabled.

Compose publishes TCP and UDP port 53 on all host addresses, so the LAN address is managed through OpenWrt rather than hardcoded into the port mappings.

## State

Configuration and runtime data live in `./adguard/` (gitignored). The directory
is bind-mounted into the container and persists across restarts.

## Recipes

| Command | Description |
| --- | --- |
| `just boot` | Start AdGuard Home |
| `just down` | Stop AdGuard Home |
| `just reboot` | Restart AdGuard Home |
| `just config` | Render resolved compose config |

## Ports

| Port | Protocol | Purpose |
| --- | --- | --- |
| 53 | TCP+UDP | DNS |
| 3900 | TCP | Admin Web UI |

## Notes

- AdGuard Home binds privileged DNS ports directly on the host. This is
  intentional for local-network DNS resolution.
- Do not change DNS port bindings without ensuring no other DNS server is
  running on the host.
- The DHCP server (ports 67/68) is disabled by default.
