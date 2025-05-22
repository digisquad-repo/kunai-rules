#!/bin/bash 

./_kunai-amd64 run -c ./config.rules | jq -c  > /tmp/data.json

