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

    TEMPLATE_DEPENDENCY="template_execve.dependency"
    TEMPLATE_DETECTION_EXECVE="template_execve.detection"
    TEMPLATE_DETECTION_CONNECT="template_connect.detection"

    # DEPENDENCY_TYPE_WITH_VERB=$(echo "$TEMPLATE_DEPENDENCY.$FIRST_TAG" | sed 's/template\_//')
    # DETECTION_TYPE_WITH_VERB=$(echo "$TEMPLATE_DETECTION.$FIRST_TAG" | sed 's/template\_//')

    DEPENDENCY_TYPE_WITH_VERB=$(echo "$FIRST_TAG""_list.""$TEMPLATE_DEPENDENCY" | sed 's/template\_//' | sed 's/execve\.//')
    DETECTION_TYPE_WITH_VERB_EXECVE=$(echo "$FIRST_TAG.$TEMPLATE_DETECTION_EXECVE" | sed 's/template\_//')
    DETECTION_TYPE_WITH_VERB_CONNECT=$(echo "$FIRST_TAG.$TEMPLATE_DETECTION_CONNECT" | sed 's/template\_//')

    red_echo " --------------- $TEMPLATE_DEPENDENCY.env  ---------------"
    (
        cat "$TEMPLATE_DEPENDENCY.env" |
            python3 render.py "$TEMPLATE_DEPENDENCY.j2" "$DETECTION_TYPE_WITH_VERB" "$DEPENDENCY_TYPE_WITH_VERB" "$FIRST_TAG" >"../bin/$DEPENDENCY_TYPE_WITH_VERB.yaml"
    )

    red_echo " --------------- $TEMPLATE_DETECTION_EXECVE.env  ---------------"
    (
        cat "$TEMPLATE_DETECTION_EXECVE.env" |
            python3 render.py "$TEMPLATE_DETECTION_EXECVE.j2" "$DETECTION_TYPE_WITH_VERB_EXECVE" "$DEPENDENCY_TYPE_WITH_VERB" "$FIRST_TAG" >"../bin/$DETECTION_TYPE_WITH_VERB_EXECVE.yaml"
    )
    red_echo " --------------- $TEMPLATE_DETECTION_CONNECT.env  ---------------"
    (
        cat "$TEMPLATE_DETECTION_CONNECT.env" |
            python3 render.py "$TEMPLATE_DETECTION_CONNECT.j2" "$DETECTION_TYPE_WITH_VERB_CONNECT" "$DEPENDENCY_TYPE_WITH_VERB" "$FIRST_TAG" >"../bin/$DETECTION_TYPE_WITH_VERB_CONNECT.yaml"
    )
}

if [ $# -eq 1 ]; then
    FIRST_TAG="$1"
    generateFilesFromTemplate "$FIRST_TAG"
else
    printExample
fi
