
## Table of Contents

- [Rule Architecture](#rule-architecture)
  - [Dependency Rules](#dependency-rules)
  - [Detection Rules](#detection-rules)
  - [How They Connect](#how-they-connect)
- [Using the Templater](#using-the-templater)
  - [Generating Execve Rules](#generating-execve-rules)
  - [Generating Write Rules](#generating-write-rules)
  - [Generating Connect Rules](#generating-connect-rules)
- [Testing Rules](#testing-rules)
  - [Step 1: Start Kunai in Dev Mode](#step-1-start-kunai-in-dev-mode)
  - [Step 2: Trigger the Behavior](#step-2-trigger-the-behavior)
  - [Step 3: Check for Matches](#step-3-check-for-matches)
  - [Step 4: Check for False Positives](#step-4-check-for-false-positives)
- [Regex Best Practices](#regex-best-practices)
  - [Binary Path Matching](#binary-path-matching)
  - [Config Path Matching](#config-path-matching)
  - [Common Mistakes](#common-mistakes)
- [Severity Guidelines](#severity-guidelines)
- [MITRE ATT&CK Tagging](#mitre-attck-tagging)

---

## Rule Architecture

Detection in this project follows a two-layer pattern: **dependency rules** define _what_ to look for, and **detection rules** define _when_ to alert.

### Dependency Rules

A dependency rule is a reusable building block. It declares a set of patterns (binary names, config file paths) but does not trigger any alert on its own. It has `type: dependency`.

Example -- a dependency rule that identifies SSH client binaries:

```yaml
---
name: bin_network_ssh_client_list.dependency
type: dependency
meta:
  tags: [
      "bin_network_ssh_client",
      #### #### #### #### #### #### #### #### #### #### #### ####
      "type_dependency",
      #### #### #### #### #### #### #### #### #### #### #### ####
    ]
  authors: [" hyde - Benjamin Collas - DIGISQUAD - https://www.digisquad.com"]
  comments:
    - dependency - bin_network_ssh_client_list.dependency

#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####

matches:
  $bin_dep_01: .data.exe.path ~= "/[^/]*/(ssh|scp|sftp)(-[a-zA-Z0-9._]+)?$"
  $bin_dep_02: .data.ancestors ~= "/[^/]*/(ssh|scp|sftp)(-[a-zA-Z0-9._]+)?$"

condition: any of $bin_dep_
```

Key points:

- Always match on **both** `.data.exe.path` and `.data.ancestors` for binary dependencies.
- Use `$bin_dep_01`, `$bin_dep_02`, ... as variable names.
- The condition is `any of $bin_dep_` (note the trailing underscore -- it matches all variables starting with that prefix).

### Detection Rules

A detection rule references one or more dependency rules and specifies which Kunai events should trigger evaluation. It has `type: detection`.

Example -- detect SSH client execution:

```yaml
---
name: bin_network_ssh_client.execve.detection
type: detection
meta:
  tags: [
      "bin_network_ssh_client",
      #### #### #### #### #### #### #### #### #### #### #### ####
      "type_detection",
      #### #### #### #### #### #### #### #### #### #### #### ####
      "event_execve",
      "event_execve_script",
    ]
  attack: [ T1021.004 ]
  authors: [" hyde - Benjamin Collas - DIGISQUAD - https://www.digisquad.com"]
  comments:
    - detection rule - identify EXECVE EXECVE_SCRIPT bin_network_ssh_client_list.dependency

#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####

match-on:
  events:
    kunai: [execve, execve_script]

matches:
  $bin_dep_01: rule( bin_network_ssh_client_list.dependency)
condition: $bin_dep_01

#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
severity: 5
#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####
```

### How They Connect

One dependency can serve multiple detection rules. For a single binary category you typically create:

```
bin_example_list.dependency          <-- defines the binary patterns
bin_example.execve.detection         <-- fires on execution
bin_example.connect.detection        <-- fires on network connections
```

The `rule()` function in the detection rule references the dependency by name. The gene-rs engine evaluates each dependency only once per event, so sharing them across multiple detections has no performance cost.

```
                   +----------------------------+
                   | bin_example_list.dependency |
                   | (defines binary patterns)  |
                   +-------------+--------------+
                                 |
                 +---------------+---------------+
                 |                               |
   +-------------v-----------+    +--------------v-----------+
   | bin_example.execve      |    | bin_example.connect      |
   | .detection              |    | .detection               |
   | match-on: execve,       |    | match-on: connect        |
   |   execve_script         |    | severity: 7              |
   | severity: 5             |    +---------------------------+
   +--------------------------+
```

---

## Using the Templater

The `templater_v0.1/` directory contains Jinja2 templates and shell scripts that generate rule files from environment variables. This avoids copy-paste errors and enforces the naming conventions automatically.

### Generating Execve Rules

This generates both the dependency and the execve detection rule for a new binary category.

```bash
cd templater_v0.1/

# 1. Edit the environment files with your values
#    template_execve.dependency.env -- set TARGET_TYPE and TARGET_AUTHOR
#    template_execve.detection.env  -- set TARGET_TYPE and TARGET_AUTHOR

# 2. Run the generator with your category name
bash template_execve.new.sh bin_example
```

This produces two files in the `bin/` directory:

- `bin_example.execve.dependency.yaml` -- the dependency rule
- `bin_example.execve.detection.yaml` -- the execve detection rule

After generation, edit the YAML files to fill in the actual binary names in the regex patterns.

### Generating Write Rules

For config file write detection:

```bash
cd templater_v0.1/
bash template_write.new.sh config_example
```

This produces the write dependency and write detection rules.

### Generating Connect Rules

For network connection detection (assumes a dependency rule already exists):

```bash
cd templater_v0.1/
bash template_execve.connect.new.sh bin_example
```

After generation, review the output files, adjust regex patterns, severity, and MITRE ATT&CK tags as needed, then move them into the appropriate rules directory.

---

## Testing Rules

### Step 1: Start Kunai in Dev Mode

The `dev.rules` configuration sets severity threshold to 0, so all rules will produce output regardless of severity level:

```bash
sudo -s
./scripts/_kunai-amd64.start_with_rules.sh
# Or manually:
/opt/kunai/_kunai-amd64 run -c config/dev.rules
```

Output goes to `/tmp/` by default in dev mode.

### Step 2: Trigger the Behavior

In a separate terminal, execute the action your rule should detect. Examples:

```bash
# For an execve detection of curl:
curl http://example.com

# For a config write detection of /etc/ssh/:
sudo touch /etc/ssh/test_rule_trigger && sudo rm /etc/ssh/test_rule_trigger

# For a connect detection:
python3 -c "import urllib.request; urllib.request.urlopen('http://example.com')"
```

### Step 3: Check for Matches

Use the provided scripts to find rule matches in the output:

```bash
# List all rule matches
cat /tmp/kunai_*.json | scripts/kunai.jsons.list_rules_matches.to.jsons.sh

# Filter for your specific rule
cat /tmp/kunai_*.json | scripts/kunai.jsons.list_rules_matches.to.jsons.sh | grep "your_rule_name"

# Count matches per rule
cat /tmp/kunai_*.json | scripts/kunai.jsons.count_rules_matches.to.jsons.sh
```

If your rule does not appear, check:

- Is the rule name in the config file?
- Does the `match-on` section list the correct event types?
- Is the regex matching? Test it independently: `echo "/usr/bin/curl" | grep -P '/[^/]*/(curl)(-[a-zA-Z0-9._]+)?$'`

### Step 4: Check for False Positives

Let Kunai run during a normal workload for several hours or a full day. Then review:

```bash
cat /tmp/kunai_*.json | scripts/kunai.jsons.list_rules_matches.to.jsons.sh | sort | uniq -c | sort -rn
```

Look for rules that fire excessively. Common causes of false positives:

- Regex too broad (e.g., `.*ssh.*` matches `openssh-server` during package updates)
- Ancestor matching picks up parent processes unintentionally
- Config path regex matches temporary files created by editors (e.g., vim swap files)

---

## Regex Best Practices

### Binary Path Matching

The canonical pattern for matching a binary by path:

```
/[^/]*/(binary_name)(-[a-zA-Z0-9._]+)?$
```

Breakdown:

- `/[^/]*/` -- matches exactly one directory component (e.g., `/usr/bin/`, `/sbin/`, `/usr/local/bin/`)
- `(binary_name)` -- the binary name or alternation group
- `(-[a-zA-Z0-9._]+)?` -- optional version suffix (e.g., `python-3.11`, `iptables-nft`)
- `$` -- anchored at end of string to prevent partial matches

Multiple binaries in one pattern:

```
/[^/]*/(ssh|scp|sftp|ssh-keygen)(-[a-zA-Z0-9._]+)?$
```

### Config Path Matching

For matching configuration directories and files:

```
^/etc/service(/|$)              # Directory and everything inside it
.*/etc/service/main.conf($|/)?  # A specific config file
```

Use `$r_01`, `$r_02`, ... as variable names for config path matches, with condition `any of $r_`.

### Common Mistakes

| Pattern | Problem | Fix |
|---------|---------|-----|
| `.*binary.*` | Matches anywhere in the string, causes false positives | `/[^/]*/(binary)(-[a-zA-Z0-9._]+)?$` |
| `/.*/binary` | `.*` crosses directory boundaries, matches too broadly | `/[^/]*/binary` |
| `/usr/bin/binary` | Hardcoded path, misses `/usr/local/bin/`, `/sbin/`, etc. | `/[^/]*/binary` |
| `binary$` | No leading path component, may match partial strings | `/[^/]*/(binary)(-[a-zA-Z0-9._]+)?$` |

---

## Severity Guidelines

| Severity | When to use | Examples |
|----------|-------------|---------|
| 1-2 | Informational, extremely common | (reserved for future filter rules) |
| 3 | Low -- benign tools, high frequency | `bin_editors`, `bin_daily_cmd` |
| 4 | Low-medium -- common but worth logging | `bin_browsers`, `bin_system_diag` |
| 5 | Medium -- legitimate tools to monitor | `bin_build`, `bin_network_diag`, `bin_pkg_mgmt`, `bin_script_interpreters` |
| 6 | Medium-high -- suspicious context | `bin_network_http_client`, `bin_system_wiper`, `bin_hacking_reverse` |
| 7 | High -- unusual activity | `.connect` rules for tools that rarely need network access |
| 8 | High -- likely malicious | `bin_hacking_wireless`, `bin_hacking_brute_force`, `config_*` write detections |
| 9 | Critical -- very likely malicious | `bin_hacking_mimikatz`, `bin_hacking_web`, `bin_hacking_impacket` |
| 10 | Maximum -- should never happen | `bin_editors.connect` (editors should not make network connections) |

General principle: a `.connect.detection` rule should be **higher severity** than the `.execve.detection` for the same category, because most of these tools have no legitimate reason to initiate network connections.

---

## MITRE ATT&CK Tagging

Every detection rule should include an `attack:` field in `meta:` with one or more MITRE ATT&CK technique IDs.

### How to find the right technique

1. Go to https://attack.mitre.org/techniques/enterprise/
2. Identify the tactic (what the adversary is trying to achieve): Execution, Persistence, Privilege Escalation, etc.
3. Find the technique that matches the behavior your rule detects
4. Use the technique ID (e.g., `T1059.004`) in the `attack:` field

### Quick reference for common rule categories

**Execution**
- Shell / script interpreter execution: `T1059` (sub-techniques: `.004` Unix Shell, `.006` Python, `.007` JavaScript)

**Persistence**
- Cron job modification: `T1053.003`
- Systemd service creation: `T1543.002`
- SSH authorized keys: `T1098.004`
- Shell config modification: `T1546.004`

**Discovery**
- System recon tools: `T1082` (System Information Discovery)
- Network config tools: `T1016` (System Network Configuration Discovery)
- Network scanning: `T1046` (Network Service Discovery)
- Process listing: `T1057` (Process Discovery)

**Lateral Movement**
- SSH client usage: `T1021.004`
- RDP client usage: `T1021.001`

**Credential Access**
- Credential dumping tools: `T1003`
- Brute force tools: `T1110`

**Command and Control**
- HTTP clients (curl, wget): `T1071.001`
- Tunneling tools: `T1572`
- DNS-based C2: `T1071.004`

**Defense Evasion**
- File deletion / wiping: `T1070.004`
- Disabling security tools: `T1562.001`
- Kernel module loading: `T1014` (Rootkit)

**Impact**
- Shutdown / reboot: `T1529`

For the full mapping used in this project, see the MITRE ATT&CK Mapping section in `CLAUDE.md`.

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

- [04 - Deployment](./04_DEPLOYMENT.md)
  Deploying Kunai with detection rules in production.
