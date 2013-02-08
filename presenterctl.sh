#!/bin/sh

[[ "x$1" = "xremove" ]] && exec sh -c 'xinput remove-master "remote pointer"'

xinput remove-master "remote pointer" &> /dev/null
xinput create-master remote
$(dirname $0 )/repeat-xi2 `xinput --list --id-only "remote keyboard"` 500 8

for id in `xinput --list --id-only | sed "s/[^0-9]*//g"`
do
	name=`xinput --list-props "$id" | sed -n "1s/.*'\([^']*\)'.*/\\1/p"`
	[[ "x$name" != "xLogitech USB Receiver" ]] && continue;

	xinput reattach "$id" "remote pointer"
done

echo -n "Attach 'TPPS/2 IBM TrackPoint' to 'remote pointer'? (Y/n): "
read attach
[[ "x$attach" = "xn" ]] && exit

xinput reattach "TPPS/2 IBM TrackPoint" "remote pointer"
echo -n "Type enter to attach back to core pointer."
read
xinput reattach "TPPS/2 IBM TrackPoint" "Virtual core pointer"
