#!/bin/sh

zscroll -u true -l 50 -d 2.0 -M "herbstclient attr my_mpd_scroll" -m "false" "-s 0" -M "herbstclient attr my_mpd_scroll" -m "true" "-s 1" "mpc current" &
wait

