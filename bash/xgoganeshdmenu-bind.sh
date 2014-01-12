#! /bin/bash
gogan="goganesh -file $HOME/goganesh.list"
xwindows=$(dirname $0)/xwindows.sh
#! /bin/bash
goganesh=$($gogan)
wnames=$(exec "$xwindows")
bins=$(dmenu_path)

wname=$(printf "%s\n" "$goganesh" "$wnames" "$bins" | uniq | dmenu -nb '#151617' -nf '#d8d8d8' -sb '#d8d8d8' -sf '#151617') && \

{
  wid=$(exec "$xwindows" "$wname")
  $($gogan $wname)
  if [[ -n "$wid" ]]; then
    xdotool windowraise $wid; xdotool windowfocus $wid
  else
    $(exec $wname)
  fi
}
