#!/bin/sh
# script based on https://github.com/ray-pH/waybar-cava
# font based on https://github.com/and3rson/graph-bars-font

pkill -fi polybar_cava

bar="、。〃〄々〆〇〈〉"      # U+3000: '　'
dict="s/;//g;"

# creating "dictionary" to replace char with bar
i=0
while [ $i -lt ${#bar} ]
do
    dict="${dict}s/$i/${bar:$i:1}/g;"
    i=$((i=i+1))
done

# write cava config
config_file="/tmp/polybar_cava_config"
echo "
[general]
bars = 256

framerate = 60
sleep_timer = 15

lower_cutoff_freq = 20
higher_cutoff_freq = 20000

autosens = 1
sensitivity = 150

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 8

channels = stereo
reverse = 0

[smoothing]
noise_reduction = 17

" > $config_file

# read stdout from cava
cava -p $config_file | while read -r line; do
    echo $line | sed $dict
done
