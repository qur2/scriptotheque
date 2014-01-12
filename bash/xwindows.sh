#! /bin/bash
wids=$(xdotool search --onlyvisible --name "")

function wname_to_wid {
  for wid in $wids; do
    wname=$(xdotool getwindowname $wid)
    if [[ "$wname" == "$1" ]]; then
      echo $wid
      break
    fi
  done
}

function wnames {
  for wid in $wids; do
    wname=$(xdotool getwindowname $wid)
    if [[ -n "$wname" ]]; then
      echo $wname
    fi
  done
}

if [[ -z "$1" ]]; then
  wnames
else
  wname_to_wid "$1"
fi
