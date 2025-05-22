# kunai-rules


## What you will find here


This repository contains a selection of Kunai rules that I use as an alternative to auditd and particularly for monitoring my systems and/or analysing suspicious (or not) binary files. These rules can be especially useful when used along side tools like strace and others tools.

In addition to the rule sets, this repository also includes a few scripts I personally use to streamline the analysis of Kunai logs. These small utilities are designed to simplify day-to-day tasks and are intended to be added to your system's PATH for quick access. A brief description of each tool is provided below.


## Why I created theses rules 


The core idea behind these rules is simple: In most real-world attack scenarios, an adversary will eventually either use existing tooling on the system or modify configuration files to establish persistence.

With that in mind, this rule set focuses on two main detection strategies:

1. **Monitoring for changes to critical configuration files**  
   These include files commonly abused for persistence or privilege escalation. The rules are designed to detect specific modifications that could indicate tampering or unauthorized configuration changes.

2. **Identifying uncommon or potentially dangerous tooling**  
   By cataloging most utilities typically found on a system and classifying them based on usage frequency and risk level, the rules highlight activity involving:
   - Rarely used or suspicious binaries
   - Tools commonly abused during post-exploitation
   - Dual-use utilities leveraged in living-off-the-land techniques
   - ect

I think this approach aims to reduce noise while maintaining strong coverage of techniques often missed by more generic or purely signature-based systems. 


## Why I wrote these scripts

While Kunai provides rich and detailed event data, working directly with raw JSON logs can quickly become tedious — especially during investigations or live system monitoring. I created these scripts to streamline that process.

They help with:
- Filtering events by type (e.g., connect, exec, write, etc.)
- Simplifying and formatting JSON output for readability
- Extracting specific fields such as command lines or network activity
- Correlating behaviors across different event types
- ...

The goal was simple: to be faster and make the logs more actionable for me. I use these scripts daily, and I keep them in my `$PATH` for quick access during incident response or routine system monitoring.

## New to Kunai?

Here's how the author describes it:

> **Kunai** is a powerful tool designed to bring actionable insights for tasks such as security monitoring and threat hunting on Linux systems. Think of it as the Linux counterpart to Sysmon on Windows, tailored for comprehensive and precise event monitoring.

URL : https://github.com/kunai-project/kunai

If you're the kind of person who investigates every unusual system behavior, even a subtle variation in the sound frequency of your CPU fan, Kunai is made for you.
And if you're a ninja, Kunai might just become your weapon of choice... though I must confess, I still have a soft spot for the katana. :)


## Usage Guides

These documents show how you can actually use the tools and rules provided in this repository.

- [01 – Script usage guide](./doc/01_HOWTOUSE_SCRIPTS.md) - Use the script to filter, inspect, and trace events using quick shell scripts toolkits.
- [02 – Repo rules based guide](./doc/02_HOWTOUSE_RULES.md) - Intro to the logic behind the detection rules and how to use the rules in this repository.
