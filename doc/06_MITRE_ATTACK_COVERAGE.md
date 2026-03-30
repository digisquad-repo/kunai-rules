# MITRE ATT&CK Coverage Report

**Kunai eBPF Detection Rules -- MITRE ATT&CK Mapping**

Generated: 2026-03-28

---

## Summary

| Metric | Value |
|--------|-------|
| Total detection rules | 200 |
| MITRE ATT&CK techniques covered | 92 |
| MITRE ATT&CK tactics covered | 12 of 14 |
| Kunai event types used | 17+ |

The rules span the full kill chain from initial execution through exfiltration and impact, with the strongest coverage in **Defense Evasion** (33 rules across 16 techniques), **Command and Control** (32 rules across 10 techniques), and **Credential Access** (20 rules across 10 techniques).

---

## Coverage by Tactic

### Execution (TA0002) -- 15 rules, 3 techniques

| Technique ID | Technique Name | Rules |
|-------------|----------------|-------|
| T1059 | Command and Scripting Interpreter | 5 |
| T1059.004 | Unix Shell | 9 |
| T1059.007 | JavaScript/Node | 1 |

### Persistence (TA0003) -- 24 rules, 16 techniques

| Technique ID | Technique Name | Rules |
|-------------|----------------|-------|
| T1037.004 | RC Scripts | 1 |
| T1037.005 | Startup Items | 1 |
| T1053.001 | At (Scheduled Task) | 1 |
| T1053.003 | Cron | 2 |
| T1098 | Account Manipulation | 2 |
| T1098.004 | SSH Authorized Keys | 2 |
| T1136 | Create Account | 1 |
| T1505.003 | Web Shell | 4 |
| T1543.002 | Systemd Service | 1 |
| T1546 | Event Triggered Execution | 2 |
| T1546.004 | Unix Shell Configuration Modification | 2 |
| T1547.006 | Kernel Modules and Extensions | 3 |
| T1556.003 | Pluggable Authentication Modules (PAM) | 1 |
| T1574.006 | Dynamic Linker Hijacking (LD_PRELOAD) | 1 |

### Privilege Escalation (TA0004) -- 9 rules, 3 techniques

| Technique ID | Technique Name | Rules |
|-------------|----------------|-------|
| T1548.001 | Setuid and Setgid | 3 |
| T1548.003 | Sudo and Sudo Caching | 2 |
| T1611 | Escape to Host (Container Escape) | 4 |

### Defense Evasion (TA0005) -- 33 rules, 16 techniques

| Technique ID | Technique Name | Rules |
|-------------|----------------|-------|
| T1014 | Rootkit | 3 |
| T1027.002 | Software Packing | 1 |
| T1036 | Masquerading | 1 |
| T1036.003 | Rename System Utilities | 1 |
| T1070.002 | Clear Linux or Mac System Logs | 2 |
| T1070.003 | Clear Command History | 2 |
| T1070.004 | File Deletion | 3 |
| T1070.006 | Timestomp | 1 |
| T1140 | Deobfuscate/Decode Files or Information | 1 |
| T1222 | File and Directory Permissions Modification | 1 |
| T1562.001 | Disable or Modify Tools | 5 |
| T1562.004 | Disable or Modify System Firewall | 4 |
| T1562.006 | Indicator Blocking | 1 |
| T1564.001 | Hidden Files and Directories | 1 |
| T1610 | Deploy Container | 4 |
| T1620 | Reflective Code Loading | 2 |

### Credential Access (TA0006) -- 20 rules, 10 techniques

| Technique ID | Technique Name | Rules |
|-------------|----------------|-------|
| T1003 | OS Credential Dumping | 5 |
| T1003.007 | Proc Filesystem | 1 |
| T1003.008 | /etc/passwd and /etc/shadow | 1 |
| T1110 | Brute Force | 2 |
| T1552.001 | Credentials In Files | 1 |
| T1552.004 | Private Keys | 3 |
| T1555 | Credentials from Password Stores | 1 |
| T1557.001 | LLMNR/NBT-NS Poisoning and SMB Relay | 2 |
| T1557.002 | ARP Cache Poisoning | 2 |
| T1558 | Steal or Forge Kerberos Tickets | 2 |

### Discovery (TA0007) -- 20 rules, 9 techniques

| Technique ID | Technique Name | Rules |
|-------------|----------------|-------|
| T1016 | System Network Configuration Discovery | 2 |
| T1018 | Remote System Discovery | 1 |
| T1033 | System Owner/User Discovery | 2 |
| T1046 | Network Service Discovery (Scanning) | 2 |
| T1049 | System Network Connections Discovery | 4 |
| T1057 | Process Discovery | 2 |
| T1082 | System Information Discovery | 4 |
| T1083 | File and Directory Discovery | 2 |
| T1518 | Software Discovery | 1 |

### Lateral Movement (TA0008) -- 8 rules, 4 techniques

| Technique ID | Technique Name | Rules |
|-------------|----------------|-------|
| T1021.001 | Remote Desktop Protocol (RDP) | 2 |
| T1021.002 | SMB/Windows Admin Shares | 2 |
| T1021.004 | SSH | 2 |
| T1550 | Use Alternate Authentication Material | 2 |

### Collection (TA0009) -- 12 rules, 5 techniques

| Technique ID | Technique Name | Rules |
|-------------|----------------|-------|
| T1005 | Data from Local System | 6 |
| T1039 | Data from Network Shared Drive | 2 |
| T1113 | Screen Capture | 1 |
| T1119 | Automated Collection | 2 |
| T1560.001 | Archive via Utility | 1 |

### Command and Control (TA0011) -- 32 rules, 10 techniques

| Technique ID | Technique Name | Rules |
|-------------|----------------|-------|
| T1071 | Application Layer Protocol | 3 |
| T1071.001 | Web Protocols | 5 |
| T1071.002 | File Transfer Protocols | 2 |
| T1071.004 | DNS | 5 |
| T1090 | Proxy | 1 |
| T1095 | Non-Application Layer Protocol | 3 |
| T1105 | Ingress Tool Transfer | 5 |
| T1205 | Traffic Signaling | 1 |
| T1568.001 | Fast Flux DNS | 1 |
| T1572 | Protocol Tunneling | 6 |

### Exfiltration (TA0010) -- 9 rules, 5 techniques

| Technique ID | Technique Name | Rules |
|-------------|----------------|-------|
| T1041 | Exfiltration Over C2 Channel | 2 |
| T1048 | Exfiltration Over Alternative Protocol | 3 |
| T1048.002 | Exfiltration Over Asymmetric Encrypted Non-C2 | 1 |
| T1052 | Exfiltration Over Physical Medium | 1 |
| T1567.002 | Exfiltration to Cloud Storage | 2 |

### Impact (TA0040) -- 10 rules, 6 techniques

| Technique ID | Technique Name | Rules |
|-------------|----------------|-------|
| T1485 | Data Destruction | 2 |
| T1486 | Data Encrypted for Impact (Ransomware) | 1 |
| T1489 | Service Stop | 1 |
| T1496 | Resource Hijacking / Cryptomining | 3 |
| T1529 | System Shutdown/Reboot | 2 |
| T1531 | Account Access Removal | 1 |

---

## Event Type Coverage

| Event Type | Rules | Notes |
|-----------|-------|-------|
| execve / execve_script | 71 | Binary execution -- the primary detection surface |
| connect | 50 | Network connections -- often higher severity than execve |
| write | 39 | File write events |
| write_close | 38 | File write completion |
| write_config | 35 | Configuration file modification |
| dns_query | 7 | DNS resolution monitoring |
| file_create | 5 | New file creation |
| read_config | 4 | Configuration file reads |
| prctl | 4 | Process control (name masquerading, capabilities) |
| file_unlink | 4 | File deletion |
| send_data | 4 | Outbound data transfer (exfiltration detection) |
| init_module | 2 | Kernel module loading |
| kill | 2 | Signal delivery (security tool tampering) |
| file_rename | 2 | File renaming (masquerading, log tampering) |
| bpf_prog_load + bpf_socket_filter | 1 | eBPF program loading |
| ptrace | 1 | Process tracing (injection, debugging) |
| io_uring_sqe | 1 | io_uring submission queue events |
| clone | 1 | Process creation |
| mmap_exec | 1 | Executable memory mapping |
| mprotect_exec | 1 | Memory protection change to executable |

---

## Gaps and Future Work

### Tactics not yet covered

- **Initial Access (TA0001)** -- Kunai operates post-exploitation at the endpoint level; initial access vectors (phishing, exploit delivery) are typically covered by network/email security layers. However, detecting exploitation artifacts (e.g., unusual child processes of web servers) could partially address this gap.
- **Resource Development (TA0042)** -- Pre-attack infrastructure preparation is out of scope for endpoint detection.

### Techniques with limited coverage

| Area | Gap | Potential Approach |
|------|-----|--------------------|
| T1055 (Process Injection) | Only 1 ptrace rule | Add mmap_exec/mprotect_exec rules for non-JIT processes; monitor /proc/*/mem writes |
| T1071.004 (DNS C2) | 7 dns_query rules | Expand with DGA detection (high entropy domain names), DNS tunneling (long query strings, high query frequency) |
| T1048 (Exfiltration) | 4 send_data rules | Add entropy-based detection (data_entropy > 7.0 to public IPs from non-browser processes) |
| T1070 (Indicator Removal) | Limited file_unlink coverage | Add rules for /var/log/ deletion, audit log tampering |
| T1036 (Masquerading) | 2 file_rename + 1 prctl rule | Expand file_rename rules to detect renaming to known system binary names |
| T1562 (Impair Defenses) | 2 kill rules | Add rules for killing specific security processes (kunai, wazuh, ossec, auditd, falco) |

### Event types with expansion potential

- **send_data** -- Currently 4 rules. High value for exfiltration detection using data_entropy thresholds and destination analysis.
- **clone** -- Currently 1 rule. Could detect namespace manipulation for container escapes (CLONE_NEWNS, CLONE_NEWPID flags).
- **mmap_exec / mprotect_exec** -- Currently 1 rule each. Key for fileless malware and shellcode loader detection.
- **bpf_prog_load** -- Currently 1 rule. Important for detecting offensive eBPF tooling.
- **io_uring_sqe** -- Currently 1 rule. Emerging attack surface for bypassing seccomp and syscall-based monitoring.

### Correlation opportunities (multi-event detection)

These detection patterns require correlating multiple events and are not yet implemented:

1. **Write-then-execute** -- write_close to /tmp/ followed by execve of the same path (dropper pattern)
2. **Cron backdoor** -- config_system_cron write followed by crontab execution
3. **Reconnaissance chain** -- multiple bin_system_recon execve events from the same parent process in a short window
4. **Staged exfiltration** -- bin_compression execve followed by send_data with high entropy to a public IP

---

*This document is derived from the detection rules in the kunai-rules project. Update it when rules are added or modified.*
