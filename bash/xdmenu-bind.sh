#! /bin/bash
xwindows=$(dirname $0)/xwindows.sh
wnames=$(exec "$xwindows")
bins=$(dmenu_path)

wname=$(printf "%s\n" "$wnames" "$bins" | dmenu -nb '#151617' -nf '#d8d8d8' -sb '#d8d8d8' -sf '#151617') && \

{
  wid=$(exec "$xwindows" "$wname")
  echo "$wid | $wname"
  if [[ -n "$wid" ]]; then
    xdotool windowraise $wid; xdotool windowfocus $wid
  else
    eval "exec $wname"
  fi
}
