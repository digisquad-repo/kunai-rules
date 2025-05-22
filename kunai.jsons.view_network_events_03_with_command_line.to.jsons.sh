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
  echo -e "  $(basename "$0") - show data as connect view (test 03). t\t [STDIN : json lines] - [out : json lines] "
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
    
      {
        utc_time:     (.info.utc_time           // .utc_time),
        event_name:   (.info.event.name         // .event_name),
        host:         (.info.host.name          // .host          // "?"),
        dst_ip:       (.data.dst.ip             // .dst           // "?"),
        dst_port:     (.data.dst.port           // .dst_port      // "?"),
        dst_fqdn:     (.data.dst.hostname       // .fqdn          // "?"),
        socket:       (.data.dst.socket         // .socket        // "?"),
        bin_path:     (.data.exe.path           // .bin_path      // "?"),
        command_line: (.data.command_line // .command_line // "?"),  
        community_id: (.data.community_id       // .community_id ),
        
                                                
      }
    '
  )
fi
