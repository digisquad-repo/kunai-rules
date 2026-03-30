#!/bin/bash
# Start Kunai without detection rules (raw events only)
# Usage: ./scripts/_kunai-amd64.start_without_rules.sh

set -e
cd "$(dirname "$0")/.."

OUTPUT="/tmp/kunai_raw_$(date +%Y%m%d_%H%M%S).json"

if [ ! -f ./_kunai-amd64 ]; then
  echo "Error: _kunai-amd64 binary not found in $(pwd)"
  echo "Download it from the Kunai project: https://github.com/kunai-project/kunai"
  exit 1
fi

echo "Starting Kunai without rules (raw events)"
echo "Output: $OUTPUT"
echo "Press Ctrl+C to stop."
echo ""

./_kunai-amd64 run -c config/no_rules.rules > "$OUTPUT"
