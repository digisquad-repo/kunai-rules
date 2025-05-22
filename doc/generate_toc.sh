#!/bin/bash

#
# usage : cat 01_QUICK_DEMO_test.md | ./generate_toc.sh
#

(

    grep '^#' |
        sed -E 's/^#+ //' |
        while read -r line; do

            anchor=$(
                echo "$line" |
                    tr '[:upper:]' '[:lower:]' |
                    sed -E 's/[^a-z0-9 -]//g' |
                    sed -E 's/ /-/g'
            )
            echo "- [$line](#$anchor)"
        done

)
