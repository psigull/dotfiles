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

# write cava config -- adjust cutoffs to ear taste
config_file="/tmp/polybar_cava_config"
echo "
[input]
sample_rate = 48000

[general]
bars = 256

framerate = 60
sleep_timer = 15

lower_cutoff_freq = 50
higher_cutoff_freq = 18000

autosens = 1
sensitivity = 200

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 8

channels = stereo
reverse = 1

[smoothing]
integral = 0
gravity = 0
noise_reduction = 0

[eq]
1 = 1.33
2 = 1
3 = 1

" > $config_file

# read stdout from cava
c2="#eefffd"
cm="#16161d"
c1="#ffffff"
cava -p $config_file | while read -r line; do
    v=$(echo $line | sed $dict)
    c=$(python ~/.local/bin/colramp3.py "$v" "$c1" "$cm" "$c2" "$cm" "$c2" "$cm" "$c1")
    echo $c
done
