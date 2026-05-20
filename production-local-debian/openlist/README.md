# OpenList

OpenList file listing for the local Debian server.

- **Access**: http://localhost:3904
- **Data volumes**: `openlist-data`, `openlist-share`
- **Network**: `openlist-defnet`

## Usage
1. Set `OPENLIST_ADMIN_PASSWORD`, `UID`, and `GID` in `.env` before first run.
2. Initialize the data volume: `just volume-init env=local`.
3. Start: `just boot env=local`.
4. Stop: `just down env=local`.

## Notes
- OpenList data is stored in the `openlist-data` volume.
- The `openlist-share` volume is mounted at `/data` for storage and ownership management.
- The host path `../torrent-download` is mounted read-only at `/data/torrent-download` inside the container.
- The admin password is applied on first run via `OPENLIST_ADMIN_PASSWORD`.
