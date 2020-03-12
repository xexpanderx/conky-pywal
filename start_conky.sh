#!/bin/sh
~/.conky/conky-pywal/refresh_conky.sh
conky -c ~/.conky/conky-pywal/configs/cpu.conf&
conky -c ~/.conky/conky-pywal/configs/ram.conf&
conky -c ~/.conky/conky-pywal/configs/ssd.conf&
conky -c ~/.conky/conky-pywal/configs/ssd2.conf&
conky -c ~/.conky/conky-pywal/configs/gpu.conf&
while inotifywait -qqe modify $HOME/.cache/wal/colors.Xresources; do ~/.conky/conky-pywal/refresh_conky.sh ; done
