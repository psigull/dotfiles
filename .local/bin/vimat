#!/bin/zsh

input="$1"
split=("${(s/:/)input}")
fn="${split[1]}"
ln="${split[2]}"

foot -e nvim "+$ln" "$fn"
