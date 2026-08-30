#!/bin/sh
# Example: upload this folder to Princeton AFS web space (adjust user + host).
# Run from this directory after testing with ./serve.sh
#
#   ./deploy-rsync-example.sh
#
# Typical Princeton paths use ~/public_html for https://www.princeton.edu/~NETID/
set -e
SRC="$(cd "$(dirname "$0")" && pwd)"
REMOTE_HOST="${REMOTE_HOST:-tiger.princeton.edu}"
REMOTE_USER="${REMOTE_USER:-clubsocc}"
REMOTE_DIR="${REMOTE_DIR:-public_html}"
# Force an interactive-capable SSH session (useful for Duo / keyboard-interactive),
# and avoid pubkey attempts that can confuse repeated prompts.
RSYNC_RSH="${RSYNC_RSH:-ssh -tt -o PreferredAuthentications=keyboard-interactive,password -o PubkeyAuthentication=no}"

echo "Sync: $SRC/ -> ${REMOTE_USER}@${REMOTE_HOST}:~/${REMOTE_DIR}/"
rsync -avz --delete \
  -e "$RSYNC_RSH" \
  --no-perms --no-owner --no-group \
  --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r \
  --exclude '.git' \
  --exclude '.DS_Store' \
  --exclude 'deploy-rsync-example.sh' \
  --exclude 'serve.sh' \
  --exclude 'README.md' \
  "$SRC/" "${REMOTE_USER}@${REMOTE_HOST}:~/${REMOTE_DIR}/"

echo "Done. Open https://www.princeton.edu/~${REMOTE_USER}/"
