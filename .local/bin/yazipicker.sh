#!/bin/bash
tmp="$(mktemp -t yazi-picker.XXXXXX)"
foot -a "float-term" yazi --chooser-file "$tmp"
cat -- "$tmp"
rm -f -- "$tmp"
