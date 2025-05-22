
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
_kunai-amd64.start_with_rules.sh
```

If you prefer to run it without any rules:

```bash
_kunai-amd64.start_without_rules.sh
```

---

# Backlinks 

- [00 - How to use this](./00_HOWTOUSE.md) - How to use the repository content.
- [01 - Quick demo and overview of scripts usage](./01_QUICK_DEMO.md) - Use the script to filter, inspect, and trace events using quick shell scripts toolkits.
- [02 - Quick cheatsheet ](./02_SCRIPTS_CHEATSHEET.md) - Scripts Cheatsheet 
