#!/usr/bin/env bash

WinFloat=$(hyprctl -j activewindow | jq '.floating')
WinPinned=$(hyprctl -j activewindow | jq '.pinned')

# temporarily float if needed
if [ "$WinFloat" = "false" ] && [ "$WinPinned" = "false" ]; then
  hyprctl dispatch togglefloating
fi

# toggle pin
hyprctl dispatch pin

# restore original state
if [ "$WinFloat" = "false" ] && [ "$WinPinned" = "false" ]; then
  hyprctl dispatch togglefloating
fi
