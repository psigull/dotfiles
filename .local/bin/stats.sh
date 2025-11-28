#!/bin/sh

usg_cpu=$[100 - $(vmstat 1 2 | tail -1 | awk '{print $15}')]
usg_gpu=$(cat /sys/class/drm/card1/device/gpu_busy_percent)

mem_phys=$(free | grep Mem | awk '{printf("%d\n", $3/$2 * 100)}')
mem_swap=$(free | grep Swap | awk '{printf("%d\n", $3/$2 * 100)}')
mem_gpu=$(cat /sys/class/drm/card1/device/mem_busy_percent)

tmp_cpu=$(sensors | grep 'Tctl:' | awk '{print int($2)}')
tmp_gpu=$(sensors | grep 'junction:' | awk '{printf("%d\n", $2)}')

usg="$usg_cpu/$usg_gpu"
mem="$mem_phys/$mem_swap/$mem_gpu"
tmp="$tmp_cpu/$tmp_gpu"

echo " $usg   $mem   $tmp"

