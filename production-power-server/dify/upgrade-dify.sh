#!/bin/bash

# Required files
BASE_COMPOSE_FILE="compose.base.yml"
PROD_COMPOSE_FILE="compose.prod.yml"
ENV_FILE=".env"

# Check if required files exist
for file in "$BASE_COMPOSE_FILE" "$PROD_COMPOSE_FILE" "$ENV_FILE"; do
    if [ ! -f "$file" ]; then
        echo "Error: Required file $file not found"
        exit 1
    fi
done

# Source .env file
set -a
source "$ENV_FILE"
set +a

# Check if DIFY_VERSION is set to latest
if [ "$DIFY_VERSION" != "latest" ]; then
    echo "Error: DIFY_VERSION in .env must be set to 'latest' for this script to work"
    echo "Current value: $DIFY_VERSION"
    exit 1
fi

# Hardcoded image names with latest tag
API_IMAGE="langgenius/dify-api:latest"
WEB_IMAGE="langgenius/dify-web:latest"
PLUGIN_IMAGE="langgenius/dify-plugin-daemon:latest-local"

# Function to get current digest of a running container
get_current_digest() {
    local container_name="dify-$1"
    docker inspect --format='{{.Image}}' "$container_name" 2>/dev/null || echo ""
}

# Function to get latest digest from registry
get_latest_digest() {
    local image=$1
    docker pull "$image" >/dev/null 2>&1
    docker inspect --format='{{.Id}}' "$image" 2>/dev/null || echo ""
}

echo "Checking for updates..."
update_available=false

# Check API service
current_api=$(get_current_digest "api")
latest_api=$(get_latest_digest "$API_IMAGE")
if [ "$current_api" != "$latest_api" ]; then
    echo "API: Update available"
    update_available=true
else
    echo "API: Up to date"
fi

# Check Worker service (uses same image as API)
current_worker=$(get_current_digest "worker")
if [ "$current_worker" != "$latest_api" ]; then
    echo "Worker: Update available"
    update_available=true
else
    echo "Worker: Up to date"
fi

# Check Web service
current_web=$(get_current_digest "web")
latest_web=$(get_latest_digest "$WEB_IMAGE")
if [ "$current_web" != "$latest_web" ]; then
    echo "Web: Update available"
    update_available=true
else
    echo "Web: Up to date"
fi

# Check Plugin Daemon service
current_plugin=$(get_current_digest "plugin-daemon")
latest_plugin=$(get_latest_digest "$PLUGIN_IMAGE")
if [ "$current_plugin" != "$latest_plugin" ]; then
    echo "Plugin Daemon: Update available"
    update_available=true
else
    echo "Plugin Daemon: Up to date"
fi

# If no updates are available, exit
if [ "$update_available" = false ]; then
    echo "No updates available. Exiting."
    exit 0
fi

# If updates are available, proceed with restart
echo "Updates available. Proceeding with restart..."

# Stop and remove containers
echo "Stopping and removing containers..."
docker compose -f compose.base.yml -f compose.prod.yml rm -sf api worker web plugin_daemon

# Start services with new images
echo "Starting services with new images..."
docker compose -f compose.base.yml -f compose.prod.yml up -d api worker web plugin_daemon

# Prune old images
echo "Pruning old images..."
docker image prune -f

echo "All services have been updated to their latest versions"
