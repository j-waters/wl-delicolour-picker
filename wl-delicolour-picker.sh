#!/bin/env bash
#
# License: MIT
#
# A script to easily pick a color on a wayland session by using:
# slurp to select the location, grim to get the pixel, convert
# to make the pixel a hex number and zenity to display a nice color
# selector dialog where the picked color can be tweaked further.
#
# The script was possible thanks to the useful information on:
# https://www.trst.co/simple-colour-picker-in-sway-wayland.html
# https://unix.stackexchange.com/questions/320070/is-there-a-colour-picker-that-works-with-wayland-or-xwayland/523805#523805
#

# Check if running under wayland.
if [ "$WAYLAND_DISPLAY" = "" ]; then
    >&2 echo "This color picker must be run under a valid wayland session."
    exit 1
fi

# Get color position
position=$(slurp -b 00000000 -p)

# Hide cursor while grabbing the screenshot
swaymsg seat seat0 hide_cursor 1

sleep 0.2

# Store the hex color value using graphicsmagick or imagemagick.
if command -v /usr/bin/gm &> /dev/null; then
    color=$(grim -g "$position" -t png - \
        | /usr/bin/gm convert - -format '%[pixel:p{0,0}]' txt:- \
        | tail -n 1 \
        | rev \
        | cut -d ' ' -f 1 \
        | rev
    )
else
    color=$(grim -g "$position" -t png - \
        | convert - -format '%[pixel:p{0,0}]' txt:- \
        | tail -n 1 \
        | cut -d ' ' -f 4
    )
fi


# Show cursor
swaymsg seat seat0 hide_cursor 0

delicolour $color
