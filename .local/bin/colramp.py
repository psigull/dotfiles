#!/usr/bin/env python3
import sys

def hex_to_rgb(hex_color):
	return (    int(hex_color[1:3], 16),
				int(hex_color[3:5], 16),
				int(hex_color[5:7], 16) )

def rgb_to_hex(rgb):
	return f'#{rgb[0]:02x}{rgb[1]:02x}{rgb[2]:02x}'

def interpolate_rgb(start_rgb, end_rgb, step, total_steps):
	# avoid div by 0 if string is too short
	if total_steps < 2:
		return start_rgb
	
	ratio = step / (total_steps - 1)
	r = start_rgb[0] + (end_rgb[0] - start_rgb[0]) * ratio
	g = start_rgb[1] + (end_rgb[1] - start_rgb[1]) * ratio
	b = start_rgb[2] + (end_rgb[2] - start_rgb[2]) * ratio
	return (int(r), int(g), int(b))


if len(sys.argv) < 5:
	print("Usage: ./colramp.py 'text' '#left' '#center' '#right'", file=sys.stderr)
	sys.exit(1)

text = sys.argv[1]
left_color_hex = sys.argv[2]
center_color_hex = sys.argv[3]
right_color_hex = sys.argv[4]


text_length = len(text)
output_parts = []

left_rgb = hex_to_rgb(left_color_hex)
center_rgb = hex_to_rgb(center_color_hex)
right_rgb = hex_to_rgb(right_color_hex)

segment1_length = (text_length + 1) // 2  # includes center char if odd len
segment2_length = text_length - segment1_length

current_index = 0
for i in range(segment1_length):
	rgb = interpolate_rgb(left_rgb, center_rgb, i, segment1_length)
	color_hex = rgb_to_hex(rgb)
	char = text[current_index]
	output_parts.append(f'<span foreground="{color_hex}">{char}</span>')
	current_index += 1

for i in range(segment2_length):
	rgb = interpolate_rgb(center_rgb, right_rgb, i, segment2_length)
	color_hex = rgb_to_hex(rgb)
	char = text[current_index]
	output_parts.append(f'<span foreground="{color_hex}">{char}</span>')
	current_index += 1

print("".join(output_parts))
