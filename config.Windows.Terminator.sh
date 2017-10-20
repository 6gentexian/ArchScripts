#!/bin/bash
#
# Customize for each screen size


# 1) Goto the second panel - the one with 3 panes
sleep 0.1
xdotool key ctrl+Page_Up
sleep 0.1

# 2) Select the terminal in the upper left
sleep 0.1
xdotool key alt+Left


if [ "$HOSTNAME" = moe ]; then

    # 3) From the upper left terminal, pull the right towards you, and shrink the lower terminal
    sleep 0.1
    for i in `seq 1 4`;
        do
               xdotool key ctrl+shift+Left ctrl+shift+Left ctrl+shift+Left ctrl+shift+Left sleep 0.1
    done

    sleep 0.1
    for i in `seq 1 6`;
        do
               xdotool key ctrl+shift+Down ctrl+shift+Down ctrl+shift+Down ctrl+shift+Down sleep 0.1
    done

else

    # 3) From the upper left terminal, pull the right towards you, and shrink the lower terminal
    sleep 0.1
    for i in `seq 1 2`;
        do
               xdotool key ctrl+shift+Left ctrl+shift+Left ctrl+shift+Left ctrl+shift+Left sleep 0.1
    done

    sleep 0.1
    for i in `seq 1 4`;
        do
               xdotool key ctrl+shift+Down ctrl+shift+Down ctrl+shift+Down ctrl+shift+Down sleep 0.1
    done

fi


exit 0
