#!/bin/sh
colors=`cat $HOME/.cache/wal/colors.Xresources | grep "^*color" | tr -d "*:" | sed 's/ //g' | sed 's/#/="#/g' | sed ':a;N;$!ba;s/\n/"\n/g'`
colors="${colors}\""
cat ~/.conky/conky-pywal/templates/ram_template.lua | awk -v srch="COLORFIELD" -v repl="$colors" '{ sub(srch,repl,$0); print $0 }' > ~/.conky/conky-pywal/lua/ram.lua
cat ~/.conky/conky-pywal/templates/cpu_template.lua | awk -v srch="COLORFIELD" -v repl="$colors" '{ sub(srch,repl,$0); print $0 }' > ~/.conky/conky-pywal/lua/cpu.lua
cat ~/.conky/conky-pywal/templates/ssd_template.lua | awk -v srch="COLORFIELD" -v repl="$colors" '{ sub(srch,repl,$0); print $0 }' > ~/.conky/conky-pywal/lua/ssd.lua
cat ~/.conky/conky-pywal/templates/ssd2_template.lua | awk -v srch="COLORFIELD" -v repl="$colors" '{ sub(srch,repl,$0); print $0 }' > ~/.conky/conky-pywal/lua/ssd2.lua
cat ~/.conky/conky-pywal/templates/gpu_template.lua | awk -v srch="COLORFIELD" -v repl="$colors" '{ sub(srch,repl,$0); print $0 }' > ~/.conky/conky-pywal/lua/gpu.lua
cat ~/.conky/conky-pywal/templates/clock_template.lua | awk -v srch="COLORFIELD" -v repl="$colors" '{ sub(srch,repl,$0); print $0 }' > ~/.conky/conky-pywal/lua/clock.lua
cat ~/.conky/conky-pywal/templates/battery_template.lua | awk -v srch="COLORFIELD" -v repl="$colors" '{ sub(srch,repl,$0); print $0 }' > ~/.conky/conky-pywal/lua/battery.lua
