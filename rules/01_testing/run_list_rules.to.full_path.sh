#!/bin/bash
TARGET=$1

find . -maxdepth 1 -type f -name "$TARGET*.yaml" -exec realpath {} \; | grep "dependency" | while read -r line; do
  echo "\"$line\","
done

find . -maxdepth 1 -type f -name "$TARGET*.yaml" -exec realpath {} \; | grep -v "dependency" | while read -r line; do
  echo "\"$line\","
done
