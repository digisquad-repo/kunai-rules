## Table of Contents

- [Event filtering scripts](#event-filtering-scripts)
- [Event view scripts](#event-view-scripts)
- [Identify network activity](#identify-network-activity)
- [Identify write activity](#identify-write-activity)
- [Event type summary](#event-type-summary)
- [Rule match summary](#rule-match-summary)

---


## Event filtering scripts


The included helper scripts are organized by event type and allow you to quickly filter and inspect specific categories of events captured by Kunai.

Below is a list of the available filters:

- `kunai.jsons.filter_connect_events.to.jsons.sh` - Filters **connect** events.
- `kunai.jsons.filter_exec_events.to.jsons.sh` - Filters execution-related events such as `execve`, `execve_script`, etc.
- `kunai.jsons.filter_kill_events.to.jsons.sh` - Filters **kill** events.
- `kunai.jsons.filter_loss_events.to.jsons.sh` - Filters **loss** events 
- `kunai.jsons.filter_send_events.to.jsons.sh` - Filters **send_data** events.
- `kunai.jsons.filter_write_events.to.jsons.sh` - Filters write-related events such as `write`, `write_close`, etc.

These scripts are useful for narrowing down the data to specific behaviors during an investigation or during live monitoring.

---

## Event view scripts


If, like me, you enjoy reading raw JSON, you will likely still want to simplify the output a bit to improve readability during investigations.

The following scripts are prepared to clean up and reformat Kunai event logs for my usage. Each one accepts input from `stdin` and focuses on specific types of data:

- `kunai.jsons.view_01.to.jsons.sh` - General purpose view with simplified fields.
- `kunai.jsons.view_02.to.jsons.sh` - Alternative compact format for common event types.
- `kunai.jsons.view_events_connect.to.jsons.sh` - Focused on **connect** type events.
- `kunai.jsons.view_events_write.to.jsons.sh` - Focused on  **write**-related events.
- `kunai.jsons.view_iocs.to.jsons.sh`  -  Extracts and displays IOC from the logs.
- `kunai.jsons.view_network_events.to.jsons.sh`   - Focused view for network-related activity.

These views are particularly useful when reviewing logs manually or piping output into other tools like `jq` or `grep`.

---

## Identify network activity

To extract network-related events and trace their process ancestry:

```bash

cat /tmp/data.json | kunai.jsons.filter_connect_events.to.jsons.sh 

```

For a cleaner or minimalistic output, you can use the dedicated viewer:

```bash

cat /tmp/data.json | kunai.jsons.filter_connect_events.to.jsons.sh | kunai.jsons.view_network_events.to.jsons.sh

```

Note that you want the ancestor : 

```bash 

cat /tmp/data.json | kunai.jsons.filter_connect_events.to.jsons.sh  |  ./kunai.jsons.view_network_events_with_ancestors.to.jsons.sh 

```

### Output

```json
{
  "utc_time": "2025-05-22T08:43:54.635881361Z",
  "event_name": "connect",
  "host": "fn4x",
  "dst_ip": "74.125.206.94",
  "dst_port": 1025,
  "dst_fqdn": "google.fr",
  "socket": "?",
  "bin_path": "/usr/bin/ping",
  "community_id": "1:IlN0eV3JbS0a306GhgqfhNGOuJ8=",
  "ancestors": "/usr/bin/zsh"
}
```

---

## Identify write activity

To list all write-related events:

```bash

cat /tmp/data.json | kunai.jsons.filter_write_events.to.jsons.sh

```

For a cleaner or minimalistic output, you can use the dedicated viewer:

```bash 

cat /tmp/data.json | kunai.jsons.filter_write_events.to.jsons.sh | ./kunai.jsons.view_events_write.to.jsons.sh

```

### Output

```json 
{
  "utc_time": "2025-05-22T08:46:38.939119342Z",
  "event_name": "write_config",
  "w_filepath": "/etc/resolv.conf~",
  "exe_path": "/usr/bin/vim.basic",
  "command_line": "vim /etc/resolv.conf",
  "user": "root",
  "host": "fn4x",
  "rules": [
    "config_network_dns.write.detection"
  ],
  "severity": 8
}
```

---

## Event type summary

To get a high-level view of the types of events captured by kunai use the following command:

```bash

cat /tmp/data.json | ./kunai.jsons.count_event_types.to.jsons.sh

```

### Output

```json
 
{"count":589,"event_name":"execve"}
{"count":203,"event_name":"connect"}
{"count":53,"event_name":"execve_script"}
{"count":7,"event_name":"write"}
{"count":1,"event_name":"write_config"}
{"count":1,"event_name":"start"}


```

## Rule match summary

To get a quick overview of which detection rules were triggered use the following command : 

```bash

cat /tmp/data.json | ./kunai.jsons.count_rules_matches.to.jsons.sh

```

### Output

```json
 
{"count":568,"rules":"bin_system_shell.execve.detection"}
{"count":226,"rules":"bin_browsers.connect.detection"}
{"count":171,"rules":"bin_daily_cmd.execve.detection"}
{"count":38,"rules":"bin_pkg_mgmt.execve.detection"}
{"count":31,"rules":"bin_string_search.execve.detection"}
{"count":22,"rules":"bin_browsers.execve.detection"}
{"count":12,"rules":"bin_system_shell.connect.detection"}
{"count":12,"rules":"bin_system_recon.execve.detection"}
{"count":7,"rules":"config_system_systemd.write.detection"}
{"count":5,"rules":"bin_system_wiper.execve.detection"}
{"count":5,"rules":"bin_system_diag.execve.detection"}
{"count":4,"rules":"bin_network_admin.execve.detection"}
{"count":4,"rules":"bin_editors.detect.execve"}
{"count":2,"rules":"bin_network_ssh_client.execve.detection"}
{"count":1,"rules":"config_network_dns.write.detection"}
{"count":1,"rules":"bin_network_ssh_keys.execve.detection"}

```

To get command line associated to connect detection rules use the following command 

```bash 

cat /tmp/data.json  | ./kunai.jsons.filter_connect_events.to.jsons.sh  | grep -i vim  | ./kunai.jsons.view_network_events_04_verbose.to.jsons.sh  | ./kunai.jsons.list_command_lines.to.jsons.sh 

```

### Output

```json

{"utc_time":"2025-05-22T08:54:08.973461967Z","event_name":"execve","host":"fn4x","user":"grml","command_line":"grep -q ??"}
{"utc_time":"2025-05-22T08:54:12.945970484Z","event_name":"execve","host":"fn4x","user":"root","command_line":"sleep 3600"}

```

Or this ? 

```bash
cat /tmp/data.json \
  | ./kunai.jsons.filter_connect_events.to.jsons.sh \
  | grep -i vim \
  | ./kunai.jsons.view_network_events_04_verbose.to.jsons.sh \
  | ./kunai.jsons.list_command_lines.to.jsons.sh \
  | jq .command_line \
  | huniq
```

But I prefer oneliner:

```bash 

cat /tmp/data.json  | ./kunai.jsons.filter_connect_events.to.jsons.sh  | grep -i vim  | ./kunai.jsons.view_network_events_04_verbose.to.jsons.sh  | ./kunai.jsons.list_command_lines.to.jsons.sh | jq .command_line | huniq 

```

### Output

```json 
"curl https://www.google.com"
```

hmm or this ? 

```bash
cat /tmp/data.json \
  | ./kunai.jsons.filter_connect_events.to.jsons.sh \
  | grep -i vim \
  | ./kunai.jsons.view_network_events_04_verbose.to.jsons.sh \
  | jq 'del(.utc_time)' -c \
  | jq '{host,bin_path,dst_ip,ancestors}' -c
```

But I prefer oneliner:

```bash 

cat /tmp/data.json  | ./kunai.jsons.filter_connect_events.to.jsons.sh  | grep -i vim  | ./kunai.jsons.view_network_events_04_verbose.to.jsons.sh  |  jq 'del(.utc_time)' -c  | jq '{host,bin_path,dst_ip,ancestors}' -c 

```

### Output

```json 

{"host":"fn4x","bin_path":"/usr/bin/curl","dst_ip":"127.0.0.53","ancestors":"/usr/bin/vim.basic"}
{"host":"fn4x","bin_path":"/usr/bin/curl","dst_ip":"74.125.71.105","ancestors":"/usr/bin/vim.basic"}
{"host":"fn4x","bin_path":"/usr/bin/curl","dst_ip":"74.125.71.106","ancestors":"/usr/bin/vim.basic"}
{"host":"fn4x","bin_path":"/usr/bin/curl","dst_ip":"74.125.71.104","ancestors":"/usr/bin/vim.basic"}
{"host":"fn4x","bin_path":"/usr/bin/curl","dst_ip":"74.125.71.147","ancestors":"/usr/bin/vim.basic"}
{"host":"fn4x","bin_path":"/usr/bin/curl","dst_ip":"74.125.71.103","ancestors":"/usr/bin/vim.basic"}
{"host":"fn4x","bin_path":"/usr/bin/curl","dst_ip":"74.125.71.99","ancestors":"/usr/bin/vim.basic"}
{"host":"fn4x","bin_path":"/usr/bin/curl","dst_ip":"2a00:1450:400c:c09::63","ancestors":"/usr/bin/vim.basic"}
{"host":"fn4x","bin_path":"/usr/bin/curl","dst_ip":"2a00:1450:400c:c09::67","ancestors":"/usr/bin/vim.basic"}
{"host":"fn4x","bin_path":"/usr/bin/curl","dst_ip":"2a00:1450:400c:c09::93","ancestors":"/usr/bin/vim.basic"}
{"host":"fn4x","bin_path":"/usr/bin/curl","dst_ip":"2a00:1450:400c:c09::6a","ancestors":"/usr/bin/vim.basic"}
{"host":"fn4x","bin_path":"/usr/bin/curl","dst_ip":"74.125.71.105","ancestors":"/usr/bin/vim.basic"}


```


---

# Backlinks 

- [00 - How to use this](./00_HOWTOUSE.md) - How to use the repository content.
- [01 - Quick demo and overview of scripts usage](./01_QUICK_DEMO.md) - Use the script to filter, inspect, and trace events using quick shell scripts toolkits.
- [02 - Quick cheatsheet ](./02_SCRIPTS_CHEATSHEET.md) - Scripts Cheatsheet 
