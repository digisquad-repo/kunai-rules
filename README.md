## Table of Contents

- [Introduction](#introduction)
- [What Is Kunai?](#what-is-kunai)
- [Why This Repository?](#why-this-repository)
  - [Goals of the Rule Set](#goals-of-the-rule-set)
  - [Purpose of the Scripts](#purpose-of-the-scripts)
- [Usage Guides](#usage-guides)

---

# Kunai rules & scripts

## Introduction

This repository provides a set of **detection rules** and **shell-based helper scripts** designed to improve system visibility and threat detection on Linux using [Kunai](https://github.com/kunai-project/kunai).

Think of it as a pragmatic alternative to `auditd` — and a practical toolkit for investigating binaries, monitoring systems, or building lightweight detection pipelines.

---

## What is kunai?

As described by its author:

> Kunai is a powerful tool designed to bring actionable insights for tasks such as security monitoring and threat hunting on Linux systems. Think of it as the Linux counterpart to Sysmon on Windows, tailored for comprehensive and precise event monitoring.

If you're the kind of person who investigates every unusual system behavior — even a subtle change in CPU fan frequency — then Kunai is for you.  
Additionally, if you're a ninja, this might be your next weapon of choice... although I still prefer the katana. 😉

---

## Why this repository?

### Goals of the rule sets

Most attacks rely on one (or more) of the following:
- Existing system utilities (LOLbins, scripting, etc.)
- Modifying configuration files to establish persistence
- ...

This rule set was designed with those patterns in mind. It focuses on:
- Detecting changes to critical configuration files
- Highlighting the use of uncommon or potentially dangerous binaries
- Reducing noise while surfacing meaningful signals
- ...

For more information, see the following document : 
- [03 - Rules Structure](./doc/03_RULES_STRUCTURE.md)  



### Purpose of the scripts

Kunai's raw JSON logs are powerful, but not exactly easy to work with at scale. These scripts help:
- Filter by event type (`connect`, `write`, `exec`, etc.)
- Extract key fields (`command_line`, `ancestors`, etc.)
- Simplify JSON for quick inspection
- Chain easily with `grep`, `jq`, `less`, etc.
- ...

I use them daily and keep them in my `$PATH` for fast access during incident response and system monitoring.

For more information, see the following document : 
- [00 - How to Use This](./doc/00_HOWTOUSE.md)  
- [01 - Quick Demo and Overview of Scripts Usage](./doc/01_QUICK_DEMO.md)  
- [02 - Quick Cheatsheet](./doc/02_SCRIPTS_CHEATSHEET.md)  
---

## Usage guides

These documents demonstrate how to put the repository's tools and rules into practical use:

- [00 - How to Use This](./doc/00_HOWTOUSE.md)  
  How to use the repository content.

- [01 - Quick Demo and Overview of Scripts Usage](./doc/01_QUICK_DEMO.md)  
  Use the scripts to filter, inspect, and trace events using quick shell script toolkits.

- [02 - Quick Cheatsheet](./doc/02_SCRIPTS_CHEATSHEET.md)  
  Scripts cheatsheet for quick reference.

- [03 - Rules Structure](./doc/03_RULES_STRUCTURE.md)  
  For details on how rules are named, organized etc.
  


