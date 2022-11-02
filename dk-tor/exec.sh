#!/bin/bash
RESTORE='\033[0m'
RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\e[0;33m'

service tor start
status=$?
if [ $status -ne 0 ]; then
  echo -e "[${RED}ERROR${RESTORE}] Failed to start tor: $status"
  exit $status
fi

while sleep 600; do
  ps aux |grep tor |grep -q -v grep
  PROCESS_1_STATUS=$?
  if [ $PROCESS_1_STATUS -ne 0 ]; then
    echo -e "[${RED}ERROR${RESTORE}] Failed to start tor: $status"
    exit 1
  fi
done


