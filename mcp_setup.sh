#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  echo "Usage: ./mcp_setup.sh"
  echo "Merges required MCP servers into .cursor/mcp.json (preserves existing servers)."
  exit 0
fi

exec python3 "$REPO_ROOT/mcp_setup.py" --repo-root "$REPO_ROOT"

