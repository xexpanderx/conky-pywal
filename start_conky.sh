#!/bin/sh
./refresh_conky.sh
conky -c cpu.conf&
conky -c ram.conf&
conky -c ssd.conf&
while inotifywait -qqe modify $HOME/.cache/wal/colors.Xresources; do ./refresh_conky.sh ; done
