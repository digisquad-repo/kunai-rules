# Installation

## Requirements

- Linux kernel >= 5.8 (eBPF support)
- Root privileges (Kunai needs access to kernel probes)
- `jq` (for the helper scripts)

## 1. Download Kunai binary

Get the latest release from the Kunai project:

```bash
# From GitHub releases
# https://github.com/kunai-project/kunai/releases

# Or if the binary is included in this repo:
chmod +x _kunai-amd64
```

## 2. Verify the binary

```bash
sha256sum _kunai-amd64
# Compare with the checksum in CHECKSUMS.sha256
```

## 3. Choose a configuration profile

| Profile | File | Min Severity | Best for |
|---------|------|-------------|----------|
| Development | `config/dev.rules` | 0 | Rule writing, debugging |
| Server | `config/server.rules` | 3 | Production servers |
| Desktop | `config/desktop.rules` | 6 | Workstations |

## 4. Run

```bash
# Quick start (server profile, default)
sudo bash start.sh

# With a specific profile
sudo bash start.sh desktop
sudo bash start.sh dev

# List available profiles
bash start.sh --list
```

Logs are written to `/var/log/kunai/`.

## 5. Analyze output

```bash
# Count event types
cat /var/log/kunai/kunai_*.json | ./scripts/kunai.jsons.count_event_types.to.jsons.sh

# View matched rules
cat /var/log/kunai/kunai_*.json | ./scripts/kunai.jsons.list_rules_matches.to.jsons.sh

# Filter specific events
cat /var/log/kunai/kunai_*.json | ./scripts/kunai.jsons.filter_connect_events.to.jsons.sh
```

## Systemd Service (production)

See `doc/04_DEPLOYMENT.md` for systemd service setup and log rotation.
