# Changelog

All notable changes to the Kunai Rules repository.

## [Unreleased]

### Added
- **129 new detection rules** covering:
  - Cloud transfer tools (rclone, aws, gsutil)
  - Kernel module loading & rootkit detection
  - eBPF program abuse
  - Process injection (ptrace)
  - Shellcode execution (mmap/mprotect)
  - Process masquerading (prctl)
  - Security/critical process killing
  - Namespace manipulation & container escape
  - Privilege escalation (sudo, unshare, suid)
  - Credential harvesting & file discovery
  - DNS threat detection (exfil, fast-flux, long queries)
  - Data exfiltration (high entropy, large volume)
  - C2 communication patterns
  - File system operations (webshell, log tampering, binary masquerade)
  - Known attacker patterns (reverse shell, cryptominer, ARP poison)
  - Desktop-specific rules (browser abuse, messaging apps, code editors)
  - New config write detection (PAM, LD_PRELOAD, APT, profile.d, MOTD)
- **Configuration profiles**: `config/server.rules` (severity 3) and `config/desktop.rules` (severity 6)
- **MITRE ATT&CK tags** added to all existing rules

### Changed
- Repository restructured: scripts moved to `scripts/`, configs to `config/`
- README rewritten with quick start guide and rule category reference
- Launcher scripts improved with config selection and validation

### Infrastructure
- Added `.gitignore`
- Added `CONTRIBUTING.md` with rule authoring guide
- Added `TODO.md` with project roadmap
- Added Claude Code hook for automatic issue/commit generation
