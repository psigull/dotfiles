#!/usr/bin/env python3
import sys

def hex_to_rgb(h):
    return (int(h[1:3], 16), int(h[3:5], 16), int(h[5:7], 16))

def rgb_to_hex(r, g, b):
    return f'#{int(r):02x}{int(g):02x}{int(b):02x}'

text = sys.argv[1] if len(sys.argv) > 2 else ""
colors = [hex_to_rgb(c) for c in sys.argv[2:]]

if not text or not colors:
    print("Usage: ./gradient.py 'Text' '#Color1' '#Color2' [...]", file=sys.stderr)
    sys.exit(1 if not colors else 0)

nc = len(colors)

if nc == 1:
    h = rgb_to_hex(*colors[0])
    print("".join(f'<span foreground="{h}">{c}</span>' for c in text))
    sys.exit(0)

# Equal screen time: each color is the dominant color for len(text)/nc characters.
# We place each color at the CENTER of its zone, then interpolate between centers.
# End zones are clamped to their endpoint color (no wrap-around).
zone = len(text) / nc
centers = [(i + 0.5) * zone for i in range(nc)]

parts = []
for p, char in enumerate(text):
    if p <= centers[0]:
        r, g, b = colors[0]
    elif p >= centers[-1]:
        r, g, b = colors[-1]
    else:
        # find which pair of color centers p falls between
        i = next(i for i in range(nc - 1) if centers[i] <= p < centers[i + 1])
        t = (p - centers[i]) / (centers[i + 1] - centers[i])
        c0, c1 = colors[i], colors[i + 1]
        r = c0[0] + (c1[0] - c0[0]) * t
        g = c0[1] + (c1[1] - c0[1]) * t
        b = c0[2] + (c1[2] - c0[2]) * t
    parts.append(f'<span foreground="{rgb_to_hex(r, g, b)}">{char}</span>')

print("".join(parts))
