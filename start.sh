#!/bin/bash
# Kunai — start with detection rules
set -e
cd "$(dirname "$0")"

# --- Help ---
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "Usage: sudo bash start.sh [profile]"
  echo ""
  echo "Start Kunai eBPF threat detection with a configuration profile."
  echo "Output is written to /var/log/kunai/ (fallback: /tmp/)"
  echo ""
  echo "Profiles:"
  echo "  server    Broad detection, min severity 3 (default)"
  echo "  desktop   Focused alerts, min severity 6"
  echo "  dev       All events, min severity 0 (debug/rule writing)"
  echo ""
  echo "Options:"
  echo "  -h, --help    Show this help"
  echo "  -l, --list    List available profiles"
  echo ""
  echo "Examples:"
  echo "  sudo bash start.sh              # server profile (default)"
  echo "  sudo bash start.sh desktop      # desktop profile"
  echo "  sudo bash start.sh dev          # all events (debug)"
  exit 0
fi

# --- List ---
if [ "$1" = "-l" ] || [ "$1" = "--list" ]; then
  echo "Available profiles:"
  echo ""
  for f in config/*.rules; do
    name=$(basename "$f" .rules)
    # Extract severity from file
    sev=$(grep -oP 'min_severity:\s*\K\d+' "$f" 2>/dev/null || echo "?")
    printf "  %-12s  min_severity: %s   (%s)\n" "$name" "$sev" "$f"
  done
  echo ""
  echo "Usage: sudo bash start.sh <profile>"
  exit 0
fi

# --- Start ---
PROFILE="${1:-server}"
CONFIG="config/${PROFILE}.rules"
LOG_DIR="/var/log/kunai"
mkdir -p "$LOG_DIR"
chown root:root "$LOG_DIR"
chmod 750 "$LOG_DIR"
OUTPUT="${LOG_DIR}/kunai_${PROFILE}_$(date +%Y%m%d_%H%M%S).json"

if [ ! -f "./_kunai-amd64" ]; then
  echo "Error: _kunai-amd64 binary not found."
  echo "Download it from: https://github.com/kunai-project/kunai/releases"
  exit 1
fi

if [ ! -f "$CONFIG" ]; then
  echo "Error: profile '$PROFILE' not found."
  echo ""
  bash "$0" --list
  exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
  echo "Error: Kunai requires root."
  echo "  sudo bash start.sh $PROFILE"
  exit 1
fi

echo "Kunai starting..."
echo "  Profile: $PROFILE"
echo "  Config:  $CONFIG"
echo "  Output:  $OUTPUT"
echo "  Stop:    Ctrl+C"
echo ""

./_kunai-amd64 run -c "$CONFIG" > "$OUTPUT"
