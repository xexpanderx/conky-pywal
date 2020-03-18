#!/bin/sh
~/.conky/conky-pywal/refresh_conky.sh
conky -c ~/.conky/conky-pywal/configs/cpu.conf&
conky -c ~/.conky/conky-pywal/configs/ram.conf&
conky -c ~/.conky/conky-pywal/configs/ssd.conf&
conky -c ~/.conky/conky-pywal/configs/clock.conf&
conky -c ~/.conky/conky-pywal/configs/gpu.conf&
conky -c ~/.conky/conky-pywal/configs/battery.conf&
while inotifywait -qqe modify $HOME/.cache/wal/colors.Xresources; do ~/.conky/conky-pywal/refresh_conky.sh ; done
