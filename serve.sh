#!/bin/sh
# Local preview: http://127.0.0.1:8080/
cd "$(dirname "$0")" || exit 1
PORT="${PORT:-8080}"
echo "PMCS (new design): http://127.0.0.1:${PORT}/"
exec python3 -m http.server "$PORT"
