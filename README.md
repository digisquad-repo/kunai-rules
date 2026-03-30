## Table of Contents

- [Introduction](#introduction)
- [What Is Kunai?](#what-is-kunai)
- [Why This Repository?](#why-this-repository)
  - [Goals of the Rule Set](#goals-of-the-rule-set)
  - [Purpose of the Scripts](#purpose-of-the-scripts)
- [Quick Start](#quick-start)
- [Configuration Profiles](#configuration-profiles)
- [Rule Categories](#rule-categories)
- [Repository Structure](#repository-structure)
- [Contributing / Issues Workflow](#contributing--issues-workflow)
- [Usage Guides](#usage-guides)

---

# Kunai Rules & Scripts

## Introduction

This repository provides a set of **detection rules** and **shell-based helper scripts** designed to improve system visibility and threat detection on Linux using [Kunai](https://github.com/kunai-project/kunai).

Think of it as a pragmatic alternative to `auditd` — and a practical toolkit for investigating binaries, monitoring systems, or building lightweight detection pipelines.

---

## What is Kunai?

As described by its author:

> Kunai is a powerful tool designed to bring actionable insights for tasks such as security monitoring and threat hunting on Linux systems. Think of it as the Linux counterpart to Sysmon on Windows, tailored for comprehensive and precise event monitoring.

If you're the kind of person who investigates every unusual system behavior — even a subtle change in CPU fan frequency — then Kunai is for you.
Additionally, if you're a ninja, this might be your next weapon of choice... although I still prefer the katana.

---

## Why This Repository?

### Goals of the Rule Set

Most attacks rely on one (or more) of the following:
- Existing system utilities (LOLbins, scripting, etc.)
- Modifying configuration files to establish persistence
- Network connections to exfiltrate data or communicate with C2
- Process injection, privilege escalation, and defense evasion

This rule set was designed with those patterns in mind. It currently provides **300+ detection rules** covering:

| Category | Events covered | Examples |
|----------|---------------|----------|
| **Binary execution** | execve, execve_script | Hacking tools, system recon, compilers, browsers, editors |
| **Network connections** | connect | SSH tunnels, HTTP clients, C2 frameworks, mining pools |
| **Config file writes** | write, write_close, write_config | Cron, systemd, SSH keys, PAM, sudoers, LD_PRELOAD |
| **DNS activity** | dns_query | DNS exfiltration, fast-flux, long queries, public resolvers |
| **Data exfiltration** | send_data | High entropy data, large volume transfers |
| **Process injection** | ptrace | Non-debugger ptrace usage |
| **Shellcode** | mprotect_exec, mmap_exec | RWX memory from non-JIT processes |
| **Kernel modules** | init_module | Rootkit module loading |
| **eBPF abuse** | bpf_prog_load, bpf_socket_filter | Malicious eBPF programs |
| **Process masquerading** | prctl | PR_SET_NAME, anti-debug, capability manipulation |
| **Process killing** | kill | Killing security daemons, critical processes |
| **File operations** | file_rename, file_unlink, file_create | Log deletion, binary masquerading, webshell drops |
| **Container escape** | clone, write | Namespace manipulation, cgroup escape |

All rules are mapped to the **MITRE ATT&CK** framework.

### MITRE ATT&CK Coverage Summary

**200 detection rules** covering **92 MITRE ATT&CK techniques** across **12 tactics:**

| Tactic | Techniques | Key detections |
|--------|-----------|----------------|
| **Execution** | T1059, T1059.004, T1059.007 | Shell, Python, Node interpreters |
| **Persistence** | T1053.003, T1098.004, T1505.003, T1543.002, T1547.006, T1556.003, T1574.006 | Cron, SSH keys, webshells, systemd, kernel modules, PAM, LD_PRELOAD |
| **Privilege Escalation** | T1548.001, T1548.003, T1611 | SUID abuse, sudo, container escape |
| **Defense Evasion** | T1014, T1036, T1070, T1562, T1620 | Rootkits, masquerading, log deletion, disabling security, reflective loading |
| **Credential Access** | T1003, T1110, T1552, T1557, T1558 | Credential dumping, brute force, private keys, ARP/LLMNR poisoning, Kerberos |
| **Discovery** | T1016, T1046, T1049, T1057, T1082, T1083 | Network config, port scanning, process/system enumeration |
| **Lateral Movement** | T1021.001, T1021.002, T1021.004 | RDP, SMB, SSH |
| **Collection** | T1005, T1113, T1119 | Local data, screen capture, automated collection |
| **Command and Control** | T1071, T1095, T1105, T1572 | HTTP/DNS/FTP C2, tunneling, ingress tools |
| **Exfiltration** | T1041, T1048, T1567.002 | C2 exfil, alt protocol, cloud storage |
| **Impact** | T1485, T1496, T1529 | Data destruction, cryptomining, shutdown |

Full details: [06 - MITRE ATT&CK Coverage](./doc/06_MITRE_ATTACK_COVERAGE.md)

For details on rule structure and naming: [03 - Rules Structure](./doc/03_RULES_STRUCTURE.md)

---

### Purpose of the Scripts

Kunai's raw JSON logs are powerful, but not exactly easy to work with at scale. These scripts help:
- Filter by event type (`connect`, `write`, `exec`, etc.)
- Extract key fields (`command_line`, `ancestors`, etc.)
- Simplify JSON for quick inspection
- Chain easily with `grep`, `jq`, `less`, etc.

I use them daily and keep them in my `$PATH` for fast access during incident response and system monitoring.

---

## Quick Start

### 1. Run Kunai with rules (development/debug mode)

```bash
# All events, all severities — for rule development
sudo ./scripts/_kunai-amd64.start_with_rules.sh
```

### 2. Run Kunai with a profile

```bash
# Server: min severity 3 (catches more)
sudo ./scripts/_kunai-amd64.start_with_rules.sh config/server.rules

# Desktop: min severity 6 (less noise)
sudo ./scripts/_kunai-amd64.start_with_rules.sh config/desktop.rules
```

### 3. Analyze the output

```bash
# Count events by type
cat /tmp/kunai_*.json | ./scripts/kunai.jsons.count_event_types.to.jsons.sh

# View matched rules
cat /tmp/kunai_*.json | ./scripts/kunai.jsons.list_rules_matches.to.jsons.sh

# Filter specific events
cat /tmp/kunai_*.json | ./scripts/kunai.jsons.filter_connect_events.to.jsons.sh
cat /tmp/kunai_*.json | ./scripts/kunai.jsons.filter_exec_events.to.jsons.sh

# Formatted views
cat /tmp/kunai_*.json | ./scripts/kunai.jsons.view_01.to.jsons.sh | less
cat /tmp/kunai_*.json | ./scripts/kunai.jsons.view_network_events_04_verbose.to.jsons.sh
```

---

## Configuration Profiles

| Profile | File | Min Severity | Use Case |
|---------|------|-------------|----------|
| **Development** | `config/dev.rules` | 0 | Rule writing, debugging — captures everything |
| **Server** | `config/server.rules` | 3 | Headless servers — broad detection, manageable noise |
| **Desktop** | `config/desktop.rules` | 6 | Workstations — focused on high-confidence alerts |

All profiles load the same rule files from `rules_v0.1/`. The difference is the minimum severity threshold and event buffer tuning.

---

## Rule Categories

### Binary detection (`bin_*`)

Rules that detect execution or network activity of specific binaries.

| Category | Severity (execve / connect) | Description |
|----------|-----------------------------|-------------|
| `bin_daily_cmd` | 3 / 7 | Common commands (ls, cp, mv) |
| `bin_editors` | 3 / 10 | Text editors |
| `bin_browsers` | 4 / 5 | Web browsers |
| `bin_build` | 5 / 7 | Compilers, linkers |
| `bin_script_interpreters` | 5 / 7 | Python, perl, ruby, node |
| `bin_network_admin` | 5 / 7 | dig, nslookup, whois |
| `bin_network_http_client` | 6 / 7 | curl, wget |
| `bin_system_recon` | 6 / 7 | System enumeration tools |
| `bin_hacking_*` | 8-9 / 9-10 | Offensive tools (mimikatz, metasploit, impacket) |
| `bin_cloud_transfer` | 6 / 7 | rclone, aws cli, gsutil |
| `bin_kernel` | 5 / 7 + init_module(9) | Kernel module tools |

### Config write detection (`config_*`)

Rules that detect modification of critical configuration files.

| Category | Severity | Target |
|----------|----------|--------|
| `config_system_cron` | 8 | Cron jobs |
| `config_system_systemd` | 8 | Systemd services |
| `config_user_ssh` | 8 | SSH authorized_keys |
| `config_system_sudoers` | 8 | Sudo configuration |
| `config_system_pam` | 8 | PAM authentication |
| `config_system_ldpreload` | 9 | LD_PRELOAD (rootkit vector) |

### Network detection (`net_*`)

Rules based on network-level indicators.

| Category | Severity | Detection |
|----------|----------|-----------|
| `net_dns_exfil` | 8 | DNS-based data exfiltration |
| `net_dns_long_query` | 7 | Suspiciously long DNS queries |
| `net_exfil_high_entropy` | 8 | Encrypted/compressed data transfers |
| `net_c2_port` | 8 | Known C2 ports |
| `net_cryptominer_pool` | 9 | Mining pool connections |

### File system detection (`fs_*`)

Rules based on file system operations.

| Category | Severity | Detection |
|----------|----------|-----------|
| `fs_webshell_drop` | 9 | Script files in web server roots |
| `fs_log_deletion` | 7 | Log file deletion |
| `fs_binary_masquerade` | 8 | Renaming files to look like system binaries |
| `fs_dropped_exec` | 8 | Executable dropped in /tmp then executed |

### Known attacker patterns (`know_attacker_*`)

Rules targeting specific attacker techniques.

| Category | Severity | Detection |
|----------|----------|-----------|
| `know_attacker_reverse_shell` | 10 | /dev/tcp reverse shell |
| `know_attacker_cryptominer` | 8-9 | Cryptocurrency miner tools |
| `know_attacker_arp_poison` | 8-9 | ARP poisoning tools |

---

## Repository Structure

```
.
├── config/                         # Configuration profiles
│   ├── dev.rules                   # Development (severity 0 — all events)
│   ├── server.rules                # Server (severity 3 — broad detection)
│   ├── desktop.rules               # Desktop (severity 6 — focused alerts)
│   ├── no_rules.rules              # Baseline (no rules, raw events)
│   └── data.ioc                    # IoC data file
├── rules_v0.1/                     # All detection rules (300+ YAML files)
│   ├── bin_*.detection.yaml        # Binary detection rules
│   ├── bin_*_list.dependency.yaml  # Binary dependency lists
│   ├── config_*.detection.yaml     # Config write detection rules
│   ├── fs_*.detection.yaml         # File system detection rules
│   ├── net_*.detection.yaml        # Network detection rules
│   ├── know_attacker_*.yaml        # Known attacker patterns
│   └── path_*.dependency.yaml      # Path dependency lists
├── scripts/                        # Helper scripts
│   ├── _kunai-amd64.start_*.sh     # Launcher scripts
│   └── kunai.jsons.*.sh            # JSON processing utilities
├── doc/                            # Documentation
├── templater_v0.1/                 # Rule templates (Jinja2)
├── _kunai-amd64                    # Kunai binary (Linux amd64)
├── CHECKSUMS.sha256                # Binary integrity verification
├── INSTALL.md                      # Installation guide
├── CONTRIBUTING.md                 # Rule authoring guide
└── CHANGELOG.md                    # Release history
```

---

## Contributing / Issues Workflow

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full guide on adding rules.

A Claude Code hook automatically generates issue descriptions and git commit scripts when rules are added or modified.

### Commit message format

```
feat: bin_cloud_transfer (#42) - cloud storage transfer tool detection
chore: bin_browsers (#43) - update MITRE ATT&CK tags
fix: bin_network_admin (#44) - remove duplicate dig/nslookup entries
docs: readme (#45) - update documentation
```

---

## Usage Guides

- [00 - How to Use This](./doc/00_HOWTOUSE.md)
  How to use the repository content.

- [01 - Quick Demo and Overview of Scripts Usage](./doc/01_QUICK_DEMO.md)
  Use the scripts to filter, inspect, and trace events using quick shell script toolkits.

- [02 - Quick Cheatsheet](./doc/02_SCRIPTS_CHEATSHEET.md)
  Scripts cheatsheet for quick reference.

- [03 - Rules Structure](./doc/03_RULES_STRUCTURE.md)
  For details on how rules are named, organized etc.

- [04 - Deployment](./doc/04_DEPLOYMENT.md)
  Systemd service, log rotation, SIEM integration.

- [05 - Rule Development](./doc/05_RULE_DEVELOPMENT.md)
  How to create new detection rules, use the templater, test and validate.

- [06 - MITRE ATT&CK Coverage](./doc/06_MITRE_ATTACK_COVERAGE.md)
  Full technique coverage matrix with rule references.

---

**Author:** hyde - Benjamin Collas - [DIGISQUAD](https://www.digisquad.com)
