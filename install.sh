#!/bin/bash
mkdir -p ~/.conky/conky-pywal/
cp -r templates ~/.conky/conky-pywal/
cp -r lua ~/.conky/conky-pywal/
cp -r configs ~/.conky/conky-pywal/
cp start_conky.sh ~/.conky/conky-pywal/
cp refresh_conky.sh ~/.conky/conky-pywal/
chmod +x ~/.conky/conky-pywal/start_conky.sh
chmod +x ~/.conky/conky-pywal/refresh_conkys.sh
~/.conky/conky-pywal/start_conky.sh&
