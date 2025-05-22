#!/bin/bash

#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####

stdinWarning() {
  echo "" >&2
  echo " :: nothing from STDIN ; exit." >&2
  echo "" >&2
  showExample
}

showExample() {

  echo "cat /tmp/data.json | $(basename "$0") "
  echo " "
}

#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####

if [ "$1" = '-h' ] || [ "$1" = '--help' ]; then
  echo NAME
  echo -e "  $(basename "$0") - counts and sorts events type.\t\t[STDIN : json lines] - [out : json lines] "
  echo
  echo SYNOPSIS
  echo "  $(basename "$0") [-h|--help]"
  echo
  echo EXAMPLE
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
      jq -r '(.info.event.name // .event_name)' |
      sort |
      uniq -c |
      sort -nr |
      (
        jq -R -c '
          split(" ") |
          map(select(length > 0)) |
          {
            count: .[0] | tonumber, event_name: .[1]
          }
      '
      )
  )
fi
