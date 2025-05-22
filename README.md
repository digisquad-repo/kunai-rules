# Kunai rules & scripts 

## Introduction

This repository provides a set of **detection rules** and **shell-based helper scripts** designed to improve system visibility and threat detection on Linux using [Kunai](https://github.com/kunai-project/kunai).

Think of it as a pragmatic alternative to `auditd` and a practical toolkit for investigating binaries, monitoring systems, or building lightweight detection pipelines.

---

## What is kunai?

As described by its author:

> Kunai is a powerful tool designed to bring actionable insights for tasks such as security monitoring and threat hunting on Linux systems. Think of it as the Linux counterpart to Sysmon on Windows, tailored for comprehensive and precise event monitoring.

If you're the kind of person who investigates every unusual system behavior even a subtle change in CPU fan frequency then kunai is for you.  
Additionnaly, if you're a ninja, this might be your next weapon of choice... although I still prefer the katana. 😉

---

## Why this repository?

### Goals of the rules set

Most attacks rely on either:
- Existing system utilities (LOLbins, scripting, etc.)
- Modifying configuration files to establish persistence
- ...

This rule set was designed with those patterns in mind. It focuses on:
- Detecting changes to critical configuration files
- Highlighting usage of uncommon or potentially dangerous binaries
- Reducing noise while surfacing meaningful signals
- ...

### Purpose of the scripts

Kunai's raw JSON logs are powerful, but not exactly easy to work with at scale. These scripts help:
- Filter by event type (`connect`, `write`, `exec`, etc.)
- Extract key fields (`command_line`, `ancestors`, etc.)
- Simplify JSON for quick inspection
- Chain easily with `grep`, `jq`, `less`, etc.
- ...

I use them daily and keep them in my `$PATH` for fast access during incident response and system monitoring.

---

## Usage guides

These documents demonstrate how to put the repository's tools and rules into practical use:

- [01 – Script usage guide](./doc/01_HOWTOUSE_SCRIPTS.md) - Use the scripts to filter, inspect, and trace events using small shell tools.
- [02 – Rule-based detection guide](./doc/02_HOWTOUSE_RULES.md) -  Understand the logic behind the rules and how to apply them for effective monitoring.

