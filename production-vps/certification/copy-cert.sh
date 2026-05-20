#!/usr/bin/env bash
set -euo pipefail

remote_user="${REMOTE_USER:-cx}"
remote_host="${REMOTE_HOST:-10.0.0.3}"
remote_dir="${REMOTE_DIR:-~/nginx/certificate/letsencrypt-cert}"
local_cert_dir="${LOCAL_CERT_DIR:-letsencrypt-cert}"

if [[ ! -d "${local_cert_dir}" ]]; then
  echo "Error: source directory '${local_cert_dir}' not found" >&2
  exit 1
fi

if ! command -v rsync >/dev/null 2>&1; then
  echo "Error: rsync is not installed. Please install it first." >&2
  exit 1
fi

echo "Starting certificate copy to remote VM..."
echo "Remote: ${remote_user}@${remote_host}:${remote_dir}"

rsync -avz --update "${local_cert_dir}/" "${remote_user}@${remote_host}:${remote_dir}/"

echo "Certificates copied successfully."
