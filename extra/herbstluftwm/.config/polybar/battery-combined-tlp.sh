#!/bin/sh

# note: once acpi_call is installed, replace tail -5 with tail -2
battery=$(sudo tlp-stat -b | tail -5 | head -n 1 | tr -d -c "[:digit:],.")

if [ $(bc <<< "$battery > 66.6") == 1 ]; then
    echo "%{F#665c54} %{F-}$battery%"
elif [ $(bc <<< "$battery > 33.3") == 1 ]; then
    echo "%{F#665c54} %{F-}$battery%"
else
    echo "%{F#665c54} %{F-}$battery%"
fi
