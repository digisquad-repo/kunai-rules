# Contributing to Kunai Rules

## Adding a New Detection Rule

### 1. Use the templater (recommended)

```bash
cd templater_v0.1/
# Generate a new binary detection rule (execve + connect + dependency)
bash template_execve.new.sh
```

Or create the YAML manually following the conventions below.

### 2. Naming conventions

**Detection rules:** `{category}.{event}.detection.yaml`
**Dependency rules:** `{category}_list.dependency.yaml`

**Category prefixes:**
- `bin_*` — binary/executable detection
- `config_*` — configuration file write detection
- `fs_*` — file system operation detection
- `net_*` — network-level indicator detection
- `know_attacker_*` — known attacker tool/pattern detection

### 3. Required fields

Every rule MUST include:

```yaml
# One-line description of what this rule detects
---
name: category.event.detection
type: detection
meta:
  tags: [...]
  attack: [ T1234 ]     # MITRE ATT&CK technique ID(s)
  authors: [" your name "]
  comments:
    - detection rule - description

match-on:
  events:
    kunai: [event_name]

matches:
  $var: .data.field ~= "pattern"
condition: $var

severity: 5              # 1-10, see severity scale in CLAUDE.md
```

### 4. Quality checklist

Before submitting:

- [ ] Rule name follows naming convention
- [ ] File name matches rule name: `{rule_name}.yaml`
- [ ] Tags include category, type, and event tags
- [ ] `meta.attack` has MITRE ATT&CK technique ID(s)
- [ ] `# description` comment on line 1
- [ ] Regex uses canonical pattern: `/[^/]*/(binary)(-[a-zA-Z0-9._]+)?$`
- [ ] Both `.data.exe.path` AND `.data.ancestors` covered (for binary rules)
- [ ] Severity follows the scale (see CLAUDE.md)
- [ ] No duplicate binaries within the same dependency list

### 5. Testing

```bash
# Start Kunai with dev config (captures all events)
sudo bash start.sh dev

# Check that your rule triggers
cat /var/log/kunai/kunai_*.json | ./scripts/kunai.jsons.list_rules_matches.to.jsons.sh | grep your_rule_name
```

## Commit Messages

Follow the convention:

```
feat: category_name (#issue_id) - short description     # new rules
chore: category_name (#issue_id) - update description    # updates to existing rules
fix: category_name (#issue_id) - fix description         # bug fixes
docs: description (#issue_id) - documentation changes    # documentation
```

## Reporting Issues

Use GitHub Issues with:
- Rule name or category affected
- Event type
- Expected vs actual behavior
- Sample event JSON (if available)
