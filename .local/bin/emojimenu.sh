#!/bin/sh

CACHE_FILE="$HOME/.cache/emoji_list.txt"
RECENTS_FILE="$HOME/.cache/emoji_recents.txt"

mkdir -p "$(dirname "$CACHE_FILE")"
touch "$RECENTS_FILE"

if [[ ! -f "$CACHE_FILE" ]]; then
	python3 -c "
import unicodedata
ranges = [(0x2600, 0x27BF), (0x1F300, 0x1F6FF), (0x1F700, 0x1F9FF), (0x1FA00, 0x1FAFF)]
for start, end in ranges:
    for i in range(start, end + 1):
        try:
            char = chr(i)
            name = unicodedata.name(char)
            if i == 0x2764: char += '\ufe0f'; name = 'red heart'
            print(f'{char} {name.lower()}')
        except ValueError: continue
" > "$CACHE_FILE"

	echo "(づ｡◕‿‿◕｡)づ kaomoji happy" >> "$CACHE_FILE"
    echo "¯\_(ツ)_/¯ kaomoji shrug" >> "$CACHE_FILE"
    echo "(╯°□°)╯︵ ┻━┻ kaomoji flip" >> "$CACHE_FILE"
	echo "┬─┬ノ( º _ ºノ) kaomoji unflip" >> "$CACHE_FILE"
    echo "🖖 vulcan live long and prosper" >> "$CACHE_FILE"
	echo "🜃 grounding/anchor" >> "$CACHE_FILE"
	echo "♥ ascii heart" >> "$CACHE_FILE"
fi

selection=$(cat "$RECENTS_FILE" "$CACHE_FILE" | awk '!visited[$0]++' | fzf \
	--reverse \
	--border=none \
	--prompt="> " \
	--bind "double-click:accept" \
	--color=bg+:-1,fg+:white,hl:blue,fg:gray)

# If a selection was made
if [[ -n "$selection" ]]; then
	# extract just the emoji
	emoji=$(echo "$selection" | awk '{print $1}')

    echo -n "$emoji" | wl-copy

	echo "$selection" > "$RECENTS_FILE.tmp"
	cat "$RECENTS_FILE" | grep -v -F "$selection" | head -n 19 >> "$RECENTS_FILE.tmp"
	mv "$RECENTS_FILE.tmp" "$RECENTS_FILE"
fi
