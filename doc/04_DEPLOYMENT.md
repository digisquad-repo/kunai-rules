
## Table of Contents

- [Production Directory Structure](#production-directory-structure)
- [Systemd Service Setup](#systemd-service-setup)
- [Log Rotation](#log-rotation)
- [SIEM Integration Patterns](#siem-integration-patterns)
  - [Elasticsearch / Kibana (Filebeat)](#elasticsearch--kibana-filebeat)
  - [Splunk (Universal Forwarder)](#splunk-universal-forwarder)
  - [Wazuh](#wazuh)
  - [Generic: Syslog, Rsyslog, Fluentd](#generic-syslog-rsyslog-fluentd)
- [Security Considerations](#security-considerations)

---

## Production Directory Structure

A production deployment uses three directories:

```
/opt/kunai/                  # Kunai binary
/opt/kunai/_kunai-amd64      # The binary itself

/etc/kunai/                  # Configuration and rules
/etc/kunai/config.rules      # Main config (points to rule files)
/etc/kunai/rules/            # Detection, dependency, and filter YAML files

/var/log/kunai/              # JSON log output
/var/log/kunai/kunai.json    # Primary log file
```

Create the directories:

```bash
sudo mkdir -p /opt/kunai /etc/kunai/rules /var/log/kunai
```

Copy the binary, config, and rules into place:

```bash
sudo cp _kunai-amd64 /opt/kunai/_kunai-amd64
sudo cp config/server.rules /etc/kunai/config.rules
sudo cp rules_v0.1/*.yaml /etc/kunai/rules/
```

---

## Systemd Service Setup

Create the unit file at `/etc/systemd/system/kunai.service`:

```ini
[Unit]
Description=Kunai eBPF Threat Detection
Documentation=https://github.com/kunai-project/kunai
After=network.target
Wants=network.target

[Service]
Type=simple
ExecStart=/opt/kunai/_kunai-amd64 run -c /etc/kunai/config.rules
StandardOutput=append:/var/log/kunai/kunai.json
StandardError=journal
Restart=on-failure
RestartSec=5
User=root
Group=root

# Hardening (optional but recommended)
ProtectHome=read-only
ReadOnlyPaths=/etc/kunai
NoNewPrivileges=no

[Install]
WantedBy=multi-user.target
```

Enable and start the service:

```bash
sudo systemctl daemon-reload
sudo systemctl enable kunai.service
sudo systemctl start kunai.service
```

Verify it is running:

```bash
sudo systemctl status kunai.service
journalctl -u kunai.service -f
```

---

## Log Rotation

Kunai writes JSON events continuously to `/var/log/kunai/kunai.json`. Without rotation this file will grow indefinitely. Create a logrotate configuration at `/etc/logrotate.d/kunai`:

```
/var/log/kunai/*.json {
    daily
    rotate 14
    compress
    delaycompress
    missingok
    notifempty
    copytruncate
    create 0640 root root
}
```

Key options explained:

- `daily` : rotate once per day
- `rotate 14` : keep 14 days of history
- `compress` / `delaycompress` : gzip old logs, skip the most recent rotated file (so log shippers can finish reading it)
- `copytruncate` : copy the current file then truncate it in place, so Kunai does not need to be restarted or signaled
- `create 0640 root root` : set strict permissions on new log files

Test the configuration:

```bash
sudo logrotate --debug /etc/logrotate.d/kunai
```

---

## SIEM Integration Patterns

Kunai outputs one JSON object per line. This format is natively supported by all major log shippers.

### Elasticsearch / Kibana (Filebeat)

Install Filebeat and add an input for Kunai logs.

`/etc/filebeat/filebeat.yml` (relevant snippet):

```yaml
filebeat.inputs:
  - type: log
    enabled: true
    paths:
      - /var/log/kunai/kunai.json
    json.keys_under_root: true
    json.add_error_key: true
    json.message_key: log

output.elasticsearch:
  hosts: ["https://elasticsearch:9200"]
  index: "kunai-%{+yyyy.MM.dd}"
```

Start Filebeat:

```bash
sudo systemctl enable filebeat
sudo systemctl start filebeat
```

### Splunk (Universal Forwarder)

Configure a monitor input in `/opt/splunkforwarder/etc/system/local/inputs.conf`:

```ini
[monitor:///var/log/kunai/kunai.json]
disabled = false
sourcetype = _json
index = kunai
```

Set the forwarding destination in `outputs.conf`:

```ini
[tcpout]
defaultGroup = splunk_indexers

[tcpout:splunk_indexers]
server = splunk-indexer:9997
```

Restart the forwarder:

```bash
sudo /opt/splunkforwarder/bin/splunk restart
```

### Wazuh

Wazuh agent can ingest JSON log files. Edit `/var/ossec/etc/ossec.conf` on the agent:

```xml
<localfile>
  <log_format>json</log_format>
  <location>/var/log/kunai/kunai.json</location>
</localfile>
```

Restart the agent:

```bash
sudo systemctl restart wazuh-agent
```

On the Wazuh manager, create decoders and rules to parse Kunai's JSON fields (the `info.event.name` and `detection` objects are especially useful for correlation).

### Generic: Syslog, Rsyslog, Fluentd

**Rsyslog** -- use the `imfile` module:

```
module(load="imfile")
input(type="imfile"
      File="/var/log/kunai/kunai.json"
      Tag="kunai"
      Severity="info"
      Facility="local6"
      PersistStateInterval="200"
)
```

**Fluentd** -- use the `tail` input plugin:

```
<source>
  @type tail
  path /var/log/kunai/kunai.json
  pos_file /var/log/fluentd/kunai.pos
  tag kunai
  <parse>
    @type json
  </parse>
</source>
```

**Pipe to syslog** -- as a quick alternative, you can tail the log file into logger:

```bash
tail -F /var/log/kunai/kunai.json | logger -t kunai -p local6.info &
```

This is useful for testing but not recommended for production (no backpressure handling, no state persistence).

---

## Security Considerations

Kunai runs as root with full eBPF capabilities. Protect the deployment accordingly.

### Binary ownership and permissions

```bash
sudo chown root:root /opt/kunai/_kunai-amd64
sudo chmod 0750 /opt/kunai/_kunai-amd64
```

Verify the binary hash against the official release before every deployment:

```bash
sha256sum /opt/kunai/_kunai-amd64
```

### Configuration permissions

```bash
sudo chown -R root:root /etc/kunai/
sudo chmod 0750 /etc/kunai/
sudo chmod 0640 /etc/kunai/config.rules
sudo chmod 0640 /etc/kunai/rules/*.yaml
```

Non-root users should not be able to read or modify the rules. An attacker who can edit a detection rule can blind the sensor.

### Log file permissions

```bash
sudo chown root:root /var/log/kunai/
sudo chmod 0750 /var/log/kunai/
```

The log shipper user (e.g., `filebeat`, `splunk`) needs read access. Add that user to the `root` group or create a dedicated `kunai` group:

```bash
sudo groupadd kunai
sudo chown root:kunai /var/log/kunai/
sudo chmod 0750 /var/log/kunai/
sudo usermod -aG kunai filebeat
```

### Capability requirements

Kunai requires `CAP_SYS_ADMIN` (or equivalent root privileges) to load eBPF programs. Do not attempt to run it as an unprivileged user -- it will fail silently or crash.

When running under systemd, keep `User=root` in the service file. Setting `NoNewPrivileges=no` is necessary so that Kunai can load BPF programs.

### Tamper detection

Consider monitoring the Kunai binary and config directory with an external integrity checker (AIDE, OSSEC/Wazuh file integrity monitoring, or Tripwire). If an attacker modifies the detection rules, you want an independent alert.

---

# Backlinks

These documents provide additional context for operating and extending this project:

- [00 - How to Use This](./00_HOWTOUSE.md)
  How to use the repository content.

- [01 - Quick Demo and Overview of Scripts Usage](./01_QUICK_DEMO.md)
  Use the scripts to filter, inspect, and trace events using quick shell script toolkits.

- [02 - Quick Cheatsheet](./02_SCRIPTS_CHEATSHEET.md)
  Scripts cheatsheet for quick reference.

- [03 - Rules Structure](./03_RULES_STRUCTURE.md)
  For details on how rules are named, organized etc.

- [05 - Rule Development](./05_RULE_DEVELOPMENT.md)
  How to create new detection rules from scratch or using the templater.
