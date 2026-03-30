
## Table of Contents

- [Getting Started](#getting-started)
- [Running Kunai with or without Rules](#running-kunai-with-or-without-rules)

---

## Getting Started

Reminder : Begin by running kunai as root. Before doing so, it's strongly recommended to check the integrity / security of the setup:

- Confirm the binary's hash to ensure it has not been tampered with.
- Check that the Kunai binary is owned by `root`.
- Verify that the configuration files are also owned by `root` and have appropriate permissions.

Once these checks are complete, you're ready to start. 

---

## Running Kunai with or without Rules

To start Kunai with the detection rules enabled, simply run:

```bash
scripts/_kunai-amd64.start_with_rules.sh
```

If you prefer to run it without any rules:

```bash
scripts/_kunai-amd64.start_without_rules.sh
```

---

# Backlinks 

These documents demonstrate how to put the repository's tools and rules into practical use:

- [00 - How to Use This](00_HOWTOUSE.md) — Getting started
- [01 - Quick Demo](01_QUICK_DEMO.md) — Scripts usage examples
- [02 - Cheatsheet](02_SCRIPTS_CHEATSHEET.md) — Quick reference
- [03 - Rules Structure](03_RULES_STRUCTURE.md) — Naming and organization
- [04 - Deployment](04_DEPLOYMENT.md) — Systemd, log rotation, SIEM
- [05 - Rule Development](05_RULE_DEVELOPMENT.md) — Creating new rules
- [06 - MITRE ATT&CK Coverage](06_MITRE_ATTACK_COVERAGE.md) — Technique matrix
  


