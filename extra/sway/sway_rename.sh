#!/bin/sh

TAG_NAME=$(swaymsg -t get_workspaces | jq '.[] | select(.focused==true).name' | cut -d"\"" -f2)
TAG_INDEX=$(swaymsg -t get_workspaces | jq '.[] | select(.focused==true).num' | cut -d"\"" -f2)
rofi -dmenu -p "rename [${TAG_INDEX}] ${TAG_NAME}" -l 0 | xargs swaymsg rename workspace number ${TAG_INDEX} to
