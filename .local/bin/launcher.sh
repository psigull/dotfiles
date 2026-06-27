
#!/bin/bash

CACHE_FILE="$HOME/.cache/launcher_cache.txt"
RECENTS_FILE="$HOME/.cache/launcher_recents.txt"

mkdir -p "$(dirname "$CACHE_FILE")"
touch "$RECENTS_FILE"

save_recent() {
    local app_name="$1"
    echo "$app_name" > "$RECENTS_FILE.tmp"

    # filter out the current app accurately using fixed-strings (-F) and whole-line matching (-x)
    grep -v -F -x "$app_name" "$RECENTS_FILE" | head -n 19 >> "$RECENTS_FILE.tmp"
    mv "$RECENTS_FILE.tmp" "$RECENTS_FILE"
}

if [[ ! -f "$CACHE_FILE" ]]; then
    grep -hE "^Name=" /usr/share/applications/*.desktop ~/.local/share/applications/*.desktop 2>/dev/null \
        | cut -d'=' -f2 | sort -u > "$CACHE_FILE"
fi

selection=$(cat "$RECENTS_FILE" "$CACHE_FILE" 2>/dev/null | awk '!visited[$0]++' | fzf --reverse --prompt="RUN > " --print-query)

if [ -z "$selection" ]; then
    exit 0
fi

query=$(echo "$selection" | head -n 1)
chosen=$(echo "$selection" | tail -n 1)

# if the user typed something but didn't select an item with arrow keys/enter,
# 'chosen' might be empty, but 'query' holds their raw command.
if [ -z "$chosen" ]; then
    chosen="$query"
fi

desktop_apps=$(cat "$CACHE_FILE")
if [ -n "$chosen" ] && [[ "$desktop_apps" == *"$chosen"* ]]; then
    # added -F -x to grep here to ensure 'btop++' looks for exactly 'Name=btop++'
    # instead of accidentally matching 'btop' or using '+' as a regex quantifier
    file=$(grep -l -F -x "Name=$chosen" /usr/share/applications/*.desktop ~/.local/share/applications/*.desktop 2>/dev/null | head -n 1)

    if [ -z "$file" ]; then
        # fallback just in case exact match failed due to trailing spaces in desktop files
        file=$(grep -l -F "Name=$chosen" /usr/share/applications/*.desktop ~/.local/share/applications/*.desktop 2>/dev/null | head -n 1)
    fi

    cmd=$(grep -m1 "^Exec=" "$file" | cut -d'=' -f2- | sed 's/ %[fFuUdDnNickvm]//g' | xargs)
    needs_term=$(grep "^Terminal=" "$file" | cut -d'=' -f2)
    if [ "$needs_term" = "true" ]; then
        hyprctl dispatch exec "foot sh -c '$cmd'"
        save_recent "$chosen"
    else
        hyprctl dispatch exec "$cmd"
        save_recent "$chosen"
    fi
else
    # fallback for raw commands
    hyprctl dispatch exec "foot --hold sh -c '$query'"
    # don't save these to recents as they're meant for one-offs
fi
