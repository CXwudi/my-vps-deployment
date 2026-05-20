# Watchtower

Auto-updates Docker containers on the local Debian server.

## Behavior

- Polls every 24 hours (`WATCHTOWER_POLL_INTERVAL=86400`)
- Cleans up old images after update (`WATCHTOWER_CLEANUP=true`)
- Uses `nickfedor/watchtower` fork (includes additional features)

## Recipes

| Command | Description |
|---|---|
| `just boot` | Start Watchtower |
| `just down` | Stop Watchtower |
| `just reboot` | Restart Watchtower |
| `just config` | Render resolved compose config |

## Update Scope

Watchtower updates all running containers by default. To exclude a container,
add the label `com.centurylinklabs.watchtower.enable=false` to its compose
service definition.

## Notes

- Requires access to the Docker socket (`/var/run/docker.sock`).
- The `WATCHTOWER_LABEL_ENABLE` option (commented out) can restrict updates to
  only containers with the watchtower enable label.
