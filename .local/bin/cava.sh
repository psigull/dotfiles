#!/bin/sh
# cava.sh

pkill -fi polybar_cava

c2="#eefffd"
cm="#16161d"
c1="#ffffff"

config_file="/tmp/polybar_cava_config"
cat > "$config_file" << 'EOF'
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
EOF

cava -p "$config_file" | awk -v c1="$c1" -v cm="$cm" -v c2="$c2" '
BEGIN {
    split(c1 " " cm " " c2 " " cm " " c2 " " cm " " c1, ca)
    nc = 7
    for (i = 1; i <= nc; i++) {
        r[i] = strtonum("0x" substr(ca[i], 2, 2))
        g[i] = strtonum("0x" substr(ca[i], 4, 2))
        b[i] = strtonum("0x" substr(ca[i], 6, 2))
    }
    bar[0]="、"; bar[1]="。"; bar[2]="〃"
    bar[3]="〄"; bar[4]="々"; bar[5]="〆"
    bar[6]="〇"; bar[7]="〈"; bar[8]="〉"
}
{
    gsub(/;/, "")
    len = length($0)
    if (!len) { print ""; next }
    zone = len / nc
    for (i = 1; i <= nc; i++) centers[i] = (i - 0.5) * zone
    for (p = 0; p < len; p++) {
		raw = substr($0, p + 1, 1)
		ch = (raw >= "0" && raw <= "8") ? bar[raw+0] : raw
		if (rand() >= 1/2) {
			if (p <= centers[1]) { cr=r[1]; cg=g[1]; cb=b[1] }
			else if (p >= centers[nc]) { cr=r[nc]; cg=g[nc]; cb=b[nc] }
			else for (i = 1; i < nc; i++) if (centers[i] <= p && p < centers[i+1]) {
				f = (p - centers[i]) / (centers[i+1] - centers[i])
				cr = r[i] + (r[i+1] - r[i]) * f
				cg = g[i] + (g[i+1] - g[i]) * f
				cb = b[i] + (b[i+1] - b[i]) * f
				break
			}
			printf "<span foreground=\"#%02x%02x%02x\">%s</span>", int(cr), int(cg), int(cb), ch
		} else printf "<span foreground=\"#16161d\">%s</span>", ch
	}
    print ""
}'
