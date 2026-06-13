#!/bin/bash

# the fixed script!

# Memory Stats - units in KB
mem_total=$(free | grep Mem | awk '{print $2}' | sed 's/[^0-9]//g')
mem_used=$(free | grep Mem | awk '{print $3}' | sed 's/[^0-9]//g')

# Swap Data - units in KB
swap_total=$(free | grep Swap | awk '{print $2}' | sed 's/[^0-9]//g')
swap_used=$(free | grep Swap | awk '{print $3}' | sed 's/[^0-9]//g')
[ "$swap_total" -eq 0 ] && swap_total=1

# Zram Data - units in MB (usually), convert to KB
zram_cap_k=0
zram_data_k=0
zram_comp_k=0

if command -v zramctl >/dev/null 2>&1; then
    zram_info=$(zramctl | grep "zram0")
    # grab just the numbers
    zram_disk=$(echo "$zram_info" | awk '{print $3}' | sed 's/[^0-9]//g')
    zram_data=$(echo "$zram_info" | awk '{print $4}' | sed 's/[^0-9]//g')
    zram_comp=$(echo "$zram_info" | awk '{print $6}' | sed 's/[^0-9]//g')

    # standardize to KB
    zram_cap_k=$((zram_disk * 1024))
    zram_data_k=$((zram_data * 1024))
    zram_comp_k=$((zram_comp * 1024))
fi
# --- The Three Territiories ---

# Area A: Physical Pressure
mem_phys=$((mem_used * 100 / mem_total))

# Area B: The Pool Fullness (The TARDIS interior)
# "How much of my compressed data is using the zram capacity?"
if [ "$zram_cap_k" -gt 0 ]; then
    zram_pct=$((100 * zram_data_k / zram_cap_k))
	zram_pct=$((zram_pct / 10))
else
    zram_pct=0
fi

# Area C: The Virtual Expansion (The "Pure" Weight)
# "What would my usage look like if zram didn't exist?"
# Take used physical weight, subtract zram's physical footprint.
# We use mem_used_k_scaled to ensure we're adding 18,000,000k to the 18,000,000k math.
# (if mem_total is ~32GB, that's ~32 million KB)
m_used_k_scaled=$((mem_used * 1024)) # If free is in KB, this moves it to Bytes or some other scale?
# wait, if mem_total is already 32,445,644 (KB),
# then we don't need to multiply by 1024. we just need the units to match.

# Re-calibrating units:
# if mem_total = 32,445,644 (which is ~32GB in KB)
# and zram_comp_k = 266,000 (which is ~266MB in KB)
# we just subtract them directly.

mem_pure=$(( (mem_used - zram_comp_k) * 100 / mem_total ))

# 4. Swap Percent
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
mem="$mem_phys—$mem_pure/$zram_pct/$swap_pct—$mem_gpu"
tmp="$tmp_cpu/$tmp_gpu"

echo " $usg   $mem   $tmp"
#echo "DEBUG: mem_used=$mem_used, mem_total=$mem_total, zram_cap_k=$zram_cap_k, zram_data_k=$zram_data_k, zram_comp_k=$zram_comp_k, zram_pct=$zram_pct, mem_pure=$mem_pure"
#echo "# free" && free && echo "# zramctl" && zramctl && echo "# swapon" && swapon
