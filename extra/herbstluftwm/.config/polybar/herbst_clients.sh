#!/bin/sh

# we listen for when the tag changes or when the focus changes to update
# the number of windows - we can do this since all windows are set to
# focus when opened
herbstclient --idle '(focus_changed|tag_changed)' | while read hook x y
do
    herbstclient get_attr tags.focus.client_count
done
