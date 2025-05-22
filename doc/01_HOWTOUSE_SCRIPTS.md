

## New to Kunai?

Here's how the author describes it:

> **Kunai** is a powerful tool designed to bring actionable insights for tasks such as security monitoring and threat hunting on Linux systems. Think of it as the Linux counterpart to Sysmon on Windows, tailored for comprehensive and precise event monitoring.

URL : https://github.com/kunai-project/kunai

If you're the kind of person who investigates every unusual system behavior, even a subtle variation in the sound frequency of your CPU fan, Kunai is made for you.
And if you're a ninja, Kunai might just become your weapon of choice... though I must confess, I still have a soft spot for the katana. :)


## Quick introduction

```
./_kunai-amd64.start_without_rules
```

## Getting Started



Begin by running Kunai as root. Before doing so, it's strongly recommended to check the integrity / security of the setup:

- Confirm the binary's hash to ensure it has not been tampered with.
- Check that the Kunai binary is owned by `root`.
- Verify that the configuration files are also owned by `root` and have appropriate permissions.

Once these checks are complete, you're ready to start  : 

```
sudo -s  
./_kunai-amd64.start_without_rules.sh
```

Please note that the provided script will load the necessary configuration and write the output to `/tmp/data.json`. Of course, some customization may be required depending on your setup. The goal here is to showcase what can be done quickly using the scripts and rules included in this repository.

Let's start with a simple yet effective example to demonstrate how the scripts can be used in practice. Start Kunai as `root` and let it run for a few seconds to collect some activity.


### case 01 - Trigger a sample write


In a separate terminal, simulate a simple file write using vim:

```bash
vim -c 'call writefile(["hello world."], "/tmp/hello_there")' -c 'q'
```


### case 01 - Investigate the logs


Now inspect the log output using the helper script:

```bash
cat /tmp/data.json \
  | ./kunai.jsons.view_events_write.to.jsons.sh \
  | grep -i vim \
  | jq .
```


### case 01 - output


```json
{
  "utc_time": "2025-05-21T22:54:38.485573100Z",
  "event_name": "write",
  "w_filepath": "/tmp/hello_there",
  "exe_path": "/usr/bin/vim.basic",
  "command_line": "vim -c \"call writefile([\\\"hello world.\\\"], \\\"/tmp/hello_there\\\")\" -c q",
  "user": "test_user",
  "host": "fn4x",
  "rules": null,
  "severity": null
}
```

Of course when editing a file using `vim`, the filtered output will look something like this:

```json
{
  "utc_time": "2025-05-21T23:17:54.543361489Z",
  "event_name": "write",
  "w_filepath": "/tmp/hello_there2",
  "exe_path": "/usr/bin/vim.basic",
  "command_line": "vim /tmp/hello_there2",
  "user": "test_user",
  "host": "fn4x",
  "rules": null,
  "severity": null
}
```

This example illustrates how you can easily start collecting and inspecting system activity using Kunai and the provided utilities.


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


## Case 02 – Extracting the exact command line


These views operate on the same principle and accept input via `stdin` enabling quick and flexible investigations through pipelines.
For example, to extract the exact command lines related to our `vim` write events:

```bash 
cat /tmp/data.json | ./kunai.jsons.view_events_write.to.jsons.sh |  grep -i vim | ./kunai.jsons.list_command_lines.to.jsons.sh 
```

### Sample output


```json
{
  "utc_time": "2025-05-21T22:54:38.485583619Z",
  "event_name": "write",
  "host": "fn4x",
  "user": "test_user",
  "command_line": "vim -c \"call writefile([\\\"hello world.\\\"], \\\"/tmp/hello_there\\\")\" -c q"
}
{
  "utc_time": "2025-05-21T23:17:54.644383702Z",
  "event_name": "write",
  "host": "fn4x",
  "user": "test_user",
  "command_line": "vim /tmp/hello_there2"
}
```

I believe this shoud allows you to quickly review how specific commands were executed making it easier to trace actions during an investigation.
Optionnaly, if you prefer to extract only the command line associated with a matching event, you can use the following pipeline:

```bash
cat /tmp/data.json | ./kunai.jsons.view_events_write.to.jsons.sh | grep -i vim | ./kunai.jsons.list_command_lines.to.jsons.sh | jq ".command_line"
```
In this case, I recommended to **avoid** using the `-r` flag with `jq` to prevent potential gift with escaping or formatting ;) 


## Case 03 – Extracting network activity from vim


Let’s now imagine a scenario where `vim` is used to execute a `curl` command. 

For example:

```bash
vim -c '!curl https://google.com' -c 'q'
```

In this case, `vim` launches `curl`, which initiates a connection to `google.com`. You can easily extract and view the corresponding event and its details using the following command:

```bash
cat /tmp/data.json | ./kunai.jsons.filter_connect_events.to.jsons.sh |  grep vim |  ./kunai.jsons.view_network_events.to.jsons.sh
```

### Sample Output


```json
{
  "utc_time": "2025-05-21T23:34:01.996487377Z",
  "event_name": "connect",
  "host": "fn4x",
  "dst_ip": "74.125.206.100",
  "dst_port": 443,
  "dst_fqdn": "google.com",
  "socket": "?",
  "bin_path": "/usr/bin/curl",
  "community_id": "1:UeH1kkvfwDonBFoY5MNuEZ3nL6Y=",
  "ancestors": "/usr/bin/vim.basic"
}
```


### viewing ancestor process informatio 


You can also retrieve the **ancestor** process of the command (`curl`) using a dedicated script:

```bash
cat /tmp/data.json \
  | ./kunai.jsons.filter_connect_events.to.jsons.sh \
  | grep vim \
  | ./kunai.jsons.view_network_events_with_ancestors.to.jsons.sh
```

### Output Example

```json
{
  "utc_time": "2025-05-21T23:34:01.996487377Z",
  "event_name": "connect",
  "host": "fn4x",
  "dst_ip": "74.125.206.100",
  "dst_port": 443,
  "dst_fqdn": "google.com",
  "socket": "?",
  "bin_path": "/usr/bin/curl",
  "community_id": "1:UeH1kkvfwDonBFoY5MNuEZ3nL6Y=",
  "ancestors": "/usr/bin/vim.basic"
}
```

This makes it easy to trace indirect behaviors, such as tools like `vim` spawning network-related commands, which is especially useful for detecting unexpected or suspicious activity. Hmm cool, no ? :) 

# Leveraging rules for detections

You want to see how the repoistory rules can help you in practice?  

- [Check out the rules guide](./doc/02_HOWTOUSE_RULES.md) 




# Backlinks 

- [01 – Script usage guide](./doc/01_HOWTOUSE_SCRIPTS.md) - Use the script to filter, inspect, and trace events using quick shell scripts toolkits.
- [02 – Repo rules based guide](./doc/02_HOWTOUSE_RULES.md) - Intro to the logic behind the detection rules and how to use the rules in this repository.
