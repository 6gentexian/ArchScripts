#!/bin/bash
#
# Customize for each screen size

if [ "$HOSTNAME" = moe ]; then
    # 1) Click the mouse to activate terminator
    sleep 0.5
    xdotool mousemove --sync 200 275
    xdotool mousedown 1
    xdotool mouseup 1

    # 2) Goto the second panel - the one with 3 panes
    sleep 0.1
    xdotool key ctrl+Page_Up
    sleep 0.1

    # 3) Finally, arrange things smartly
    xdotool mousemove --sync 960 75
    sleep 0.1
    xdotool mousedown 1
    sleep 0.1
    xdotool mousemove_relative --polar --sync 270 250
    sleep 0.1
    xdotool mouseup 1

    sleep 0.1
    xdotool mousemove --sync 500 555
    sleep 0.1
    xdotool mousedown 1
    sleep 0.1
    xdotool mousemove_relative --polar --sync 0 225
    sleep 0.1
    xdotool mouseup 1
else
    # 1) Click the mouse to activate terminator
    sleep 0.5
    xdotool mousemove --sync 200 275
    xdotool mousedown 1
    xdotool mouseup 1

    # 2) Goto the second panel - the one with 3 panes
    sleep 0.1
    xdotool key ctrl+Page_Up
    sleep 0.1

    # 3) Finally, arrange things smartly
    xdotool mousemove --sync 800 75
    sleep 0.1
    xdotool mousedown 1
    sleep 0.1
    xdotool mousemove_relative --polar --sync 270 200
    sleep 0.1
    xdotool mouseup 1

    sleep 0.1
    xdotool mousemove --sync 500 465
    sleep 0.1
    xdotool mousedown 1
    sleep 0.1
    xdotool mousemove_relative --polar --sync 0 200
    sleep 0.1
    xdotool mouseup 1
    
fi



