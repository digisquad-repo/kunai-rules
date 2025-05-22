#!/bin/bash 
TARGET=$1
find . -name "$1*" -exec realpath {} \;
