#!/bin/sh
colors=`cat $HOME/.cache/wal/colors.Xresources | grep "*color" | tr -d "*:" | sed 's/ //g' | sed 's/#/="#/g' | sed ':a;N;$!ba;s/\n/"\n/g'`
colors="${colors}\""
cat template/ram_template.lua | awk -v srch="COLORFIELD" -v repl="$colors" '{ sub(srch,repl,$0); print $0 }' > ram.lua
cat template/cpu_template.lua | awk -v srch="COLORFIELD" -v repl="$colors" '{ sub(srch,repl,$0); print $0 }' > cpu.lua
cat template/ssd_template.lua | awk -v srch="COLORFIELD" -v repl="$colors" '{ sub(srch,repl,$0); print $0 }' > ssd.lua
