#! /usr/bin/bash

cd ~/projects/godot/4.2/AugmenType/src/cpp/GDExtensionTemplate/

echo $'\n\nStarting step 1...\n\n'

cmake -B GDExtensionTemplate-build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=GDExtensionTemplate-install

if [ $? -ne 0 ]; then
	echo $'\n\nStep 1 Failed!\n\n'
	exit 1
fi

echo $'\n\nStep 1 Complete. Starting step 2...\n\n'

cmake --build GDExtensionTemplate-build --parallel

if [ $? -ne 0 ]; then
	echo $'\n\nStep 2 Failed!\n\n'
	exit 1
fi

echo $'\n\nStep 2 Complete. Starting step 3...\n\n'

cmake --install GDExtensionTemplate-build

if [ $? -ne 0 ]; then
	echo $'\n\nStep 3 Failed!\n\n'
	exit 1
fi

echo $'\n\nStep 3 Complete. Attempting to fix gdextention file...\n\n'

replace='linux.x86_64 = "lib/Linux-x86_64/libGDExtensionTemplate\.so"'

sed -i "s|linux.release.*|$replace|" ~/projects/godot/4.2/AugmenType/src/cpp/GDExtensionTemplate/GDExtensionTemplate-install/GDExtensionTemplate/GDExtensionTemplate.gdextension

if [ $? -ne 0 ]; then
	echo $'\n\ngdextension file fix failed!\n\n'
	exit 1
fi

echo $'gdextention file fix success! Attempting to copy compile_comands.json...\n\n'

cp -v GDExtensionTemplate-build/compile_commands.json ./

if [ $? -ne 0 ]; then
	echo $'\n\ncopy compile_comands failed!\n\n'
	exit 1
fi

echo $'\n\nCopy compile_comands.json successful!\n\n\nFull Script has been completed! Boo Yah!\n\n'

exit 0
