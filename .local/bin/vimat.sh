#!/bin/zsh

input="$1"
split=("${(s/:/)input}")
fn="${split[1]}"
ln="${split[2]}"

alacritty -e nvim "+$ln" "$fn"
