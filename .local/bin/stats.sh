#!/bin/bash

# Memory Stats
mem_total=$(free | grep Mem | awk '{print $2}' | sed 's/[^0-9]//g')
mem_used=$(free | grep Mem | awk '{print $3}' | sed 's/[^0-9]//g')

# Swap Data
swap_total=$(free | grep Swap | awk '{print $2}' | sed 's/[^0-9]//g')
swap_used=$(free | grep Swap | awk '{print $3}' | sed 's/[^0-9]//g')
[ "$swap_total" -eq 0 ] && swap_total=1

# Zram Data
zram_used=0
zram_total=1
if command -v zramctl >/dev/null 2>&1; then
    zram_info=$(zramctl | grep "zram0")
    # NAME       ALGORITHM DISKSIZE  DATA COMPR TOTAL STREAMS MOUNTPOINT
	# /dev/zram0 lz4            16G    5G  2.2G  2.3G         [SWAP]
	# col1		 col2	   col3		 col4 col5  col6  col7	  col8
	# column 3 is the total size of zram swap available from physical ram
	# column 4 is the size of zram swap usage when uncompressed
	# column 6 is the compressed size
	# for mem_pure we need to subtract the col 6 value from phys mem usage
	# for zram percent we need the total (compressed) size
    zram_used=$(echo "$zram_info" | awk '{print int($6)}')
    zram_total=$(echo "$zram_info" | awk '{print int($3)}')
fi

# Math -- leaving these, but noting: free is already in kb
m_total_k=$((mem_total))
m_used_k=$((mem_used))
# Scale zram to k (`16G` in zramctl -> mb -> kb)
zram_used_k=$((zram_used * 1024 * 1024))
zram_total_k=$((zram_total * 1024 * 1024))

# 1. mem_phys (Used / Total)
mem_phys=$((mem_used * 100 / mem_total))

# 2. mem_pure ( (Zram - Used) / Total )
mem_pure=$(( -100 * (zram_used_k - m_used_k) / m_total_k ))

# 3. zram_pct (Zram Used / Zram Total)
if [ "$zram_total" -gt 0 ]; then
    zram_pct=$((100 * zram_used_k / zram_total_k))
else
    zram_pct=0
fi

# 4. swap_pct (Swap Used / Swap Total)
if [ "$swap_total" -gt 0 ]; then
    swap_pct=$((swap_used * 100 / swap_total))
else
    swap_pct=0
fi

# GPU Stats
if [ -f /sys/class/drm/card1/device/gpu_busy_percent ]; then
    usg_gpu=$(cat /sys/class/drm/card1/device/gpu_busy_percent)
    mg_usg=$(cat /sys/class/drm/card1/device/mem_info_vram_used)
    mg_max=$(cat /sys/class/drm/card1/device/mem_info_vram_total)
    mem_gpu=$(awk "BEGIN {printf \"%d\", $mg_usg / $mg_max * 100}")
else
    usg_gpu="0"
    mem_gpu="0"
fi

# CPU & Temp
tmp_cpu=$(sensors | grep 'Tctl:' | awk '{print int($2)}' || echo "0")
tmp_gpu=$(sensors | grep 'junction:' | awk '{printf("%d\n", $2)}' || echo "0")

# CPU Usage
usg_cpu=$((100 - $(vmstat 1 2 | tail -1 | awk '{print $15}' || echo "0")))

# Output
usg="$usg_cpu/$usg_gpu"
mem="$mem_phys/$mem_gpu $mem_pure/$zram_pct/$swap_pct"
tmp="$tmp_cpu/$tmp_gpu"

#echo "DEBUG: m_used_k=$m_used_k, zram_used_k=$zram_used_k, zram_total_k=$zram_total_k, m_total_k=$m_total_k, zram_pct=$zram_pct"
echo " $usg   $mem   $tmp"
