#!/bin/bash

#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####

stdinWarning() {
  echo "" >&2
  echo " :: nothing from STDIN. exit." >&2
  echo "" >&2
  showExample
}

showExample() {

  echo "cat /tmp/data.json | $(basename "$0") "
  echo " "
  echo ""
  echo "cat /tmp/data.json | kunai.jsons.filter_connect_events.to.jsons.sh | $(basename "$0")"
  echo "cat /tmp/data.json | kunai.jsons.filter_exec_events.to.jsons.sh | $(basename "$0")"
  echo "cat /tmp/data.json | kunai.jsons.filter_loss_events.to.jsons.sh | $(basename "$0")"
  echo "cat /tmp/data.json | kunai.jsons.filter_write_events.to.jsons.sh | $(basename "$0")"
}

#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####

if [ "$1" = '-h' ] || [ "$1" = '--help' ]; then
  echo "NAME"
  echo -e "  $(basename "$0") - extract command lines from events .\t\t [STDIN : json lines] - [out : json lines] "
  echo ""
  echo "SYNOPSIS"
  echo "  $(basename "$0") [-h|--help]"
  echo ""
  echo "EXAMPLE"
  echo "  $(showExample)"
  echo
  exit 1
fi

#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####

if [ -t 0 ]; then
  stdinWarning
else
  (
    cat - |
      jq -c '{    
        utc_time:     (.info.utc_time     // .utc_time), 
        event_name:   (.info.event.name   // .event_name), 
        host:         (.info.host.name    // .host), 
        user :        (.info.task.user    // .user), 
        command_line: (.data.command_line // .command_line // "?")   
      }'
  )
fi
