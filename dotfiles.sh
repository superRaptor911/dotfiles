#!/bin/bash

base_dir=".config"
files=(
        "$base_dir/i3/"
        "$base_dir/nvim/"
        "$base_dir/alacritty/"
        "$base_dir/fish/"
        "$base_dir/lf/"
        "$base_dir/nvim/"
        "$base_dir/polybar/"
        ".Xresources"
        ".bashrc"
        ".vimrc"
        ".vim/"
    )

for i in "${files[@]}"
do
    cp -rva ~/$i ./
done
