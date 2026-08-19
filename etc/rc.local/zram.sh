#!/bin/sh

modprobe zram

#zramctl /dev/zram0 --size 16G --algorithm lz4
zramctl /dev/zram0 --size 64G --algorithm zstd

mkswap -U clear /dev/zram0
swapon --discard --priority 100 /dev/zram0
