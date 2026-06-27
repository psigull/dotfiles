#!/bin/sh
cliphist list | fzf --reverse | cliphist decode | wl-copy
