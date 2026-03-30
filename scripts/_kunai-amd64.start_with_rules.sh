#!/bin/bash
# Start Kunai with detection rules (development profile — all events, all severities)
# Usage: ./scripts/_kunai-amd64.start_with_rules.sh [config_file]

set -e
cd "$(dirname "$0")/.."

CONFIG="${1:-config/dev.rules}"
OUTPUT="/tmp/kunai_$(date +%Y%m%d_%H%M%S).json"

if [ ! -f ./_kunai-amd64 ]; then
  echo "Error: _kunai-amd64 binary not found in $(pwd)"
  echo "Download it from the Kunai project: https://github.com/kunai-project/kunai"
  exit 1
fi

if [ ! -f "$CONFIG" ]; then
  echo "Error: Config file not found: $CONFIG"
  echo "Available profiles:"
  ls -1 config/*.rules 2>/dev/null | sed 's/^/  /'
  exit 1
fi

echo "Starting Kunai with config: $CONFIG"
echo "Output: $OUTPUT"
echo "Press Ctrl+C to stop."
echo ""

./_kunai-amd64 run -c "$CONFIG" > "$OUTPUT"
