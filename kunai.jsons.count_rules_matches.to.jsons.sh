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
  echo ""
  echo "cat /tmp/data.json | kunai.jsons.filter_connect_events.to.jsons.sh |  $(basename "$0")"
  echo "cat /tmp/data.json | kunai.jsons.filter_exec_events.to.jsons.sh |  $(basename "$0")"
  echo "cat /tmp/data.json | kunai.jsons.filter_loss_events.to.jsons.sh |  $(basename "$0")"
  echo "cat /tmp/data.json | kunai.jsons.filter_write_events.to.jsons.sh |  $(basename "$0")"

  echo " "
}

#### #### #### #### #### #### #### #### #### #### #### #### #### #### #### ####

if [ "$1" = '-h' ] || [ "$1" = '--help' ]; then
  echo "NAME"
  echo -e "  $(basename "$0") - counts and sorts matched rules.\t\t [STDIN : json lines] - [out : json lines] "
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
    (
      cat - | jq -c '

      if (.detection.rules    // .rules | type) == "array" then
        (.detection.rules     // .rules)[]

      elif (.detection.rules  // .rules | type) == "string" then
        .detection.rules      // .rules

      else
        empty
      end
    '
    ) |
      sort |
      uniq -c |
      sort -nr |
      jq -R -c '
        split(" ") |
        map(select(length > 0)) |
        {
          count: .[0] | 
            tonumber, rules: .[1] |
            gsub("\""; "")
        }
    '
  )
fi
