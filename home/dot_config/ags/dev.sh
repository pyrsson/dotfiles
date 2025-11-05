#!/bin/bash

ags run --gtk 4 --define DEBUG=true &

inotifywait --quiet --monitor --event create,modify,delete --recursive . --exclude .git | while read -r directory event file; do
  case "$event" in
  "MODIFY")
    ags quit
    ags run --gtk 4 --define DEBUG=true &
    ;;
  esac
done
