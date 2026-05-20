#!/usr/bin/env bash
#
# LobeChat PostgreSQL Volume Restoration Script
# Restores the lobechat-db Docker volume from a backup archive
#

set -e  # Exit on error

# Configuration
BACKUP_FILE="${1:-$HOME/infra/backup-files/lobechat-db-daily-backup-2026-05-01T09-00-00.tar.gz}"
RESTORE_TEMP_DIR="$HOME/infra/backup-files/restore-temp"
COMPOSE_DIR="$HOME/LLMs/lobe-chat"
COMPOSE_FILES="-f compose.base.yml -f compose.prod.yml"
CONTAINER_NAME="lobechat-db"
SERVICE_NAME="db"
DATA_PATH="/var/lib/postgresql/data"

echo "========================================"
echo "LobeChat PostgreSQL Restoration"
echo "========================================"
echo "Backup file: $BACKUP_FILE"
echo ""

# Step 1: Stop services
echo "[1/8] Stopping LobeChat services..."
cd "$COMPOSE_DIR"
docker compose $COMPOSE_FILES down
echo "✓ Services stopped"
echo ""

# Step 2: Extract backup
echo "[2/8] Extracting backup archive..."
mkdir -p "$RESTORE_TEMP_DIR"
tar -xzf "$BACKUP_FILE" -C "$RESTORE_TEMP_DIR/"
echo "✓ Backup extracted to $RESTORE_TEMP_DIR"
echo ""

# Step 3: Create container without starting
echo "[3/8] Creating database container..."
cd "$COMPOSE_DIR"
docker compose $COMPOSE_FILES create "$SERVICE_NAME"
echo "✓ Container created"
echo ""

# Step 4: Restore volume data
echo "[4/8] Restoring volume data..."
docker run --rm \
  --volumes-from "$CONTAINER_NAME" \
  -v "$RESTORE_TEMP_DIR:/backup" \
  debian bash -c "rm -rf $DATA_PATH/* && cp -a /backup/backup/lobechat-db/. $DATA_PATH/"
echo "✓ Volume data restored"
echo ""

# Step 5: Remove created container
echo "[5/8] Removing temporary container..."
cd "$COMPOSE_DIR"
docker compose $COMPOSE_FILES down
echo "✓ Container removed"
echo ""

# Step 6: Start services
echo "[6/8] Starting services..."
cd "$COMPOSE_DIR"
just boot
echo "✓ Services started"
echo ""

# Step 7: Cleanup
echo "[7/8] Cleaning up temporary files..."
rm -rf "$RESTORE_TEMP_DIR"
echo "✓ Temporary files removed"
echo ""

# Step 8: Verify
echo "[8/8] Verifying restoration..."
sleep 5  # Give services time to stabilize
echo ""
echo "Container Status:"
docker ps | grep lobechat
echo ""
echo "PostgreSQL Logs (last 10 lines):"
docker logs "$CONTAINER_NAME" --tail 10
echo ""

echo "========================================"
echo "✓ Restoration completed successfully!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Check container health: docker ps | grep lobechat"
echo "2. Verify PostgreSQL logs: docker logs $CONTAINER_NAME --tail 50"
echo "3. Access LobeChat web UI to verify data"
