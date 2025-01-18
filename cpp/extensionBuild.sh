#! /usr/bin/bash

cd /home/vince/Apps/augmenExt || exit 1

bear -- scons

# TODO: add a if prev not ok check here

echo $'Attempting to restart Godot...'

killall godot

sleep 1

nohup ./home/vince/Apps/godot/bin/godot.linuxbsd.editor.x86_64 ~/Repos/AugmenType/project.godot >/dev/null

echo $'\n\nFull Script has been completed! Boo Yah!\n\n'

exit 0
