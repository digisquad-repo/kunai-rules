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
}

#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####

if [ "$1" = '-h' ] || [ "$1" = '--help' ]; then
  echo "NAME"
  echo -e "  $(basename "$0") - show data as write view (test). t\t [STDIN : json lines] - [out : json lines] "
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
      jq '
        select(
          .info.event.name == "write"        or .event_name == "write" or 
          .info.event.name == "write_config" or .event_name == "write_config" or
          .info.event.name == "write_close"  or .event_name == "write_close")
        ' |
      jq -c '
        {
          utc_time:     (.info.utc_time      // .utc_time),
          event_name:   (.info.event.name    // .event_name) ,
          w_filepath:   (.data.path          // .w_filepath),
          exe_path:     (.data.exe.path      // .exe_path     // "?"), 
          command_line: (.data.command_line  // .command_line // "?"),
          user :        (.info.task.user     // .user         // "?"), 
          host:         (.info.host.name     // .host) ,
          rules:        (.detection.rules    // .rules), 
          severity:     (.detection.severity // .severity), 
        }'
  )
fi
