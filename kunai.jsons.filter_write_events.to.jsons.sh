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
  echo -e "  $(basename "$0") - apply filter on execve/execve_scripts events from STDIN.\t\t [STDIN : json lines] - [out : json lines] "
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
    cat - | jq -c '
      select(
        .info.event.name == "write"        or .event_name == "write" or 
        .info.event.name == "write_config" or .event_name == "write_config" or
        .info.event.name == "write_close"  or .event_name == "write_close" 
      ) 
    '
  )
fi
