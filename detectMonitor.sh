#!/bin/bash

isDP1Connected() {
    local xRandr=$(xrandr -q)
    [ "$xRandr" == "${xRandr#*DP-1 con}" ] || return 0
    return 1
}

configureDisplay() {
    local lastxrandrout=$(cat /tmp/lastxrandroutput)

    if [ "$lastxrandrout" == "$1" ]; then
        echo "Nothing to do here, no change detected"
    else
        local lvdsoutput=$(xrandr | grep LVDS | grep " connected "|cut -f 1 -d ' ')
        echo "Enabling $lvdsoutput"
        xrandr --output $lvdsoutput --mode 1680x1050 --pos 1920x0 --rotate normal --output DP-3 --off --output DP-2 --off --output DP-1 --mode 1920x1080 --pos 0x0 --rotate normal --output VGA1 --off
    fi

    echo "$1" > /tmp/lastxrandroutput
}

while true; do

if isDP1Connected; then
    configureDisplay 'on'
else
    configureDisplay 'off'
fi;

sleep 10

done
