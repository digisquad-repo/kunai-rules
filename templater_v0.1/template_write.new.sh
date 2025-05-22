#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

printExample() {

    echo "  $(basename "$0") verb_name"
    echo " "
}

if [ "$1" = '-h' ] || [ "$1" = '--help' ]; then
    echo NAME
    echo "  $(basename "$0") - generate execve dependency/detection files"
    echo
    echo SYNOPSIS
    echo "  $(basename "$0") [-h|--help]"
    echo
    echo EXAMPLE
    echo "  $(printExample)"
    echo
    exit 1
fi

#### #### #### #### #### #### #### #### #### #### #### #### #### #### ####

red_echo() {
    printf "${RED}$@${NC}\n" 1>&2
}

generateFilesFromTemplate() {
    FIRST_TAG="$1"
    # TEMPLATE_DEPENDENCY="template_write.dependency"
    # TEMPLATE_DETECTION="template_write.detection"

    # DEPENDENCY_TYPE_WITH_VERB=$(echo "$TEMPLATE_DEPENDENCY.$ARG_VERB" | sed 's/template\_//')
    # DETECTION_TYPE_WITH_VERB=$(echo "$TEMPLATE_DETECTION.$ARG_VERB" | sed 's/template\_//')

    # TEMPLATE_DEPENDENCY="template_write.dependency"
    # TEMPLATE_DETECTION="template_write.detection"

    # # DEPENDENCY_TYPE_WITH_VERB=$(echo "$TEMPLATE_DEPENDENCY.$ARG_VERB" | sed 's/template\_//')
    # # DETECTION_TYPE_WITH_VERB=$(echo "$TEMPLATE_DETECTION.$ARG_VERB" | sed 's/template\_//')

    # DEPENDENCY_TYPE_WITH_VERB=$(echo "$ARG_VERB.$TEMPLATE_DEPENDENCY" | sed 's/template\_//')
    # DETECTION_TYPE_WITH_VERB=$(echo "$ARG_VERB.$TEMPLATE_DETECTION" | sed 's/template\_//')

    TEMPLATE_DEPENDENCY="template_write.dependency"
    TEMPLATE_DETECTION_WRITE="template_write.detection"
    # TEMPLATE_DETECTION_CONNECT="template_write.detection"

    # DEPENDENCY_TYPE_WITH_VERB=$(echo "$TEMPLATE_DEPENDENCY.$FIRST_TAG" | sed 's/template\_//')
    # DETECTION_TYPE_WITH_VERB=$(echo "$TEMPLATE_DETECTION.$FIRST_TAG" | sed 's/template\_//')

    DEPENDENCY_TYPE_WITH_VERB=$(echo "$FIRST_TAG""_list.""$TEMPLATE_DEPENDENCY" | sed 's/template\_//' | sed 's/execve\.//')
    DETECTION_TYPE_WITH_VERB_WRITE=$(echo "$FIRST_TAG.$TEMPLATE_DETECTION_WRITE" | sed 's/template\_//')

    echo " ::: $DEPENDENCY_TYPE_WITH_VERB "
    echo " ::: $DETECTION_TYPE_WITH_VERB_WRITE"

    # DETECTION_TYPE_WITH_VERB_CONNECT=$(echo "$FIRST_TAG.$TEMPLATE_DETECTION_CONNECT" | sed 's/template\_//')

    # red_echo " --------------- $TEMPLATE_DEPENDENCY.env  ---------------"
    # (
    #     cat "$TEMPLATE_DEPENDENCY.env" |
    #         python3 render.py "$TEMPLATE_DEPENDENCY.j2" "$DETECTION_TYPE_WITH_VERB" "$DEPENDENCY_TYPE_WITH_VERB" >"../bin/$DEPENDENCY_TYPE_WITH_VERB.yaml"
    # )

    # red_echo " --------------- $TEMPLATE_DETECTION.env  ---------------"
    # (
    #     cat "$TEMPLATE_DETECTION.env" |
    #         python3 render.py "$TEMPLATE_DETECTION.j2" "$DETECTION_TYPE_WITH_VERB" "$DEPENDENCY_TYPE_WITH_VERB" >"../bin/$DETECTION_TYPE_WITH_VERB.yaml"
    # )

    red_echo " --------------- $TEMPLATE_DEPENDENCY.env  ---------------"
    (
        cat "$TEMPLATE_DEPENDENCY.env" |
            python3 render.py "$TEMPLATE_DEPENDENCY.j2" "$DETECTION_TYPE_WITH_VERB" "$DEPENDENCY_TYPE_WITH_VERB" "$FIRST_TAG" >"../bin/$DEPENDENCY_TYPE_WITH_VERB.yaml"
    )

    red_echo " --------------- $TEMPLATE_DETECTION_WRITE.env  ---------------"
    (
        cat "$TEMPLATE_DETECTION_WRITE.env" |
            python3 render.py "$TEMPLATE_DETECTION_WRITE.j2" "$DETECTION_TYPE_WITH_VERB_WRITE" "$DEPENDENCY_TYPE_WITH_VERB" "$FIRST_TAG" >"../bin/$DETECTION_TYPE_WITH_VERB_WRITE.yaml"
    )

}

if [ $# -eq 1 ]; then
    ARG_VERB="$1"
    generateFilesFromTemplate "$ARG_VERB"
else
    printExample
fi
