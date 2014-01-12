#! /bin/bash
dim_grepper="grep -m 1 -o [[:digit:]]\{1,\}x[[:digit:]]\{1,\}"
pos_grepper="grep -m 1 -o [[:digit:]]\{1,\},[[:digit:]]\{1,\}"

screen_geom=$(xrandr | $dim_grepper)
screen_geom=(${screen_geom//x/ })

wid=$(xdotool getactivewindow)
win_pos=$(xdotool getwindowgeometry $wid | $pos_grepper)
win_pos=(${win_pos//,/ })
win_geom=$(xdotool getwindowgeometry $wid | $dim_grepper)
win_geom=(${win_geom//x/ })

function north_or_south {
	if (( win_pos[1] < screen_geom[1]/2 )); then
		echo 'north'
	else
		echo 'south'
	fi
}
function east_or_west {
	if (( win_pos[0] < screen_geom[0]/2 )); then
		echo 'west'
	else
		echo 'east'
	fi
}

if [ "$1" = "-q" ]; then
	new_win_geom=($((${screen_geom[0]}/2)) $((${screen_geom[1]}/2)))
	if [ "west" = "$(east_or_west)" ]; then
		if [ "north" = "$(north_or_south)" ]; then
			# north west => bring to north east
			echo "north east"
			new_win_pos=($((${screen_geom[0]}/2)) 0)
		else
			# south west => bring to north west
			echo "north west"
			new_win_pos=(0 0)
		fi
	else
		if [ "north" = "$(north_or_south)" ]; then
			# north east => bring to south east
			echo "south east"
			new_win_pos=($((${screen_geom[0]}/2)) $((${screen_geom[1]}/2)))
		else
			# south east => bring to south west
			echo "south west"
			new_win_pos=(0 $((${screen_geom[1]}/2)))
		fi
	fi
else
	echo "${win_geom[@]}" "$((${screen_geom[0]}/2))"
	if (( win_geom[0] < screen_geom[0] )); then
		new_win_geom=(${screen_geom[0]} $((${screen_geom[1]}/2)))
		if [ "east" = "$(east_or_west)" ]; then
			# half east => bring to half south
			echo "half south"
			new_win_pos=(0 $((${screen_geom[1]}/2)))
		else
			# half west => bring to half north
			echo "half north"
			new_win_pos=(0 0)
		fi
	else
		new_win_geom=($((${screen_geom[0]}/2)) ${screen_geom[1]})
		# wide enough, let's check if it's the upper or lower half
		if [ "north" = "$(north_or_south)" ]; then
			# half north => bring to half east
			echo "half east"
			new_win_pos=($((${screen_geom[0]}/2)) 0)
		else
			# half south => bring to half west
			echo "half west"
			new_win_pos=(0 0)
		fi
	fi
fi

xdotool windowsize $wid ${new_win_geom[@]}
xdotool windowmove $wid ${new_win_pos[@]}
