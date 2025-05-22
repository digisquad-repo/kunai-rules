## Rule files structure and naming convention

The rules in this repository follow a consistent structure and naming pattern to allow for categorization of detection logic. 
This approach combines two types of logic:

* **Detection rules**: to identify specific behaviors in event data (e.g., execution, network, write...)
* **Dependency rules**: to classify known binaries or configuration files used by these detections

---

### File naming convention

All rule files are located under a common directory (e.g. `rules_v0.1/`) and follow a predictable naming pattern:

```
[type]_[category]_[name].[verb].[type].yaml
```

Where:

* **type**: indicates whether the rule targets `bin` (binary) or `config` (configuration)
* **category**: logical grouping (e.g., `system`, `network`, `hacking`, `pkg_mgmt`, etc.)
* **name**: name of the tool, software, or component
* **verb**: type of event the rule applies to (`execve`, `connect`, `write`, etc.)
* **type (suffix)**: either `detection.yaml` or `dependency.yaml`

---

### Examples

* `bin_system_shell.execve.detection.yaml`
  - Detects execution of system shells (e.g. `/bin/bash`, `sh`, etc.)

* `config_system_cron_list.write.dependency.yaml`
  - Declares the list of known files related to system cron configuration for use in write detections

* `bin_hacking_metasploit_list.dependency.yaml`
  - Contains fingerprints of binaries associated with Metasploit

* `bin_network_http_client.execve.detection.yaml`
  - Detects execution of HTTP clients like `curl`, `wget`, etc.

---

### Rule types

#### 1. Detection rules

These define specific behavioral detections based on Kunai event fields. They typically include:

* `event_name`: type of event to match (`execve`, `write`, etc.)
* `match`: conditions or patterns (e.g., binary path, arguments, user, etc.)
* `tags`: metadata about the rule (severity, context, etc.)

#### 2. Dependency rules

These are used to define and maintain lists of known good or known suspicious binaries, paths, or configurations. 
They are often reused across multiple detection rules.


---

### Design philosophy

* **Naming = Metadata**: You can infer a rule's scope and function just by its filename.
* **Verb awareness**: Event verbs like `execve`, `connect`, and `write` drive the behavior category.
* **Dual-layer logic**: Detection rules point to external dependency definitions making them easier to maintain and/or enrich.

I suggest you add this alias  : 

```bash 
alias llg="ls -lah | grep -i $1 " 
```

Why, because :)  : 

```bash 

# llg ssh   

-rw-rw-r-- 1 redacted redacted  881 mai   22 10:02 bin_network_ssh_client.connect.detection.yaml
-rw-rw-r-- 1 redacted redacted  919 mai   22 10:02 bin_network_ssh_client.execve.detection.yaml
-rw-rw-r-- 1 redacted redacted  769 mai   22 10:02 bin_network_ssh_client_list.dependency.yaml
-rw-rw-r-- 1 redacted redacted  873 mai   22 10:02 bin_network_ssh_keys.connect.detection.yaml
-rw-rw-r-- 1 redacted redacted  911 mai   22 10:02 bin_network_ssh_keys.execve.detection.yaml
-rw-rw-r-- 1 redacted redacted  773 mai   22 10:02 bin_network_ssh_keys_list.dependency.yaml
-rw-rw-r-- 1 redacted redacted  708 mai   22 10:02 config_network_ssh.write.detection.yaml
-rw-rw-r-- 1 redacted redacted  857 mai   22 10:02 config_network_ssh_list.write.dependency.yaml
-rw-rw-r-- 1 redacted redacted  692 mai   22 10:02 config_user_ssh.write.detection.yaml
-rw-rw-r-- 1 redacted redacted 1,1K mai   22 10:02 config_user_ssh_list.write.dependency.yaml

```

You can also run  `run_list_rules.to.full_path.sh` to quickly categorize and load rule logic dynamically based on filename structure. 
*** Make sure to declare all dependency rules before any detection logic and always place exclusion rules at the top of the rule set. ***

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
  


