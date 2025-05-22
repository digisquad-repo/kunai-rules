
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

These documents demonstrate how to put the repository's tools and rules into practical use:

- [00 - How to Use This](./doc/00_HOWTOUSE.md)  
  How to use the repository content.

- [01 - Quick Demo and Overview of Scripts Usage](./doc/01_QUICK_DEMO.md)  
  Use the scripts to filter, inspect, and trace events using quick shell script toolkits.

- [02 - Quick Cheatsheet](./doc/02_SCRIPTS_CHEATSHEET.md)  
  Scripts cheatsheet for quick reference.

- [03 - Rules Structure](./doc/03_RULES_STRUCTURE.md)  
  For details on how rules are named, organized etc.
  


