#!/bin/bash

base_dir=".config"
files=(
        ".Xresources"
        ".bashrc"
        ".vimrc"
    )

for i in "${files[@]}"
do
    cp -rva ~/$i ./
done


files=(
        "$base_dir/i3/"
        "$base_dir/nvim/"
        "$base_dir/alacritty/"
        "$base_dir/fish/"
        "$base_dir/lf/"
        "$base_dir/nvim/"
        "$base_dir/polybar/"
    )


mkdir -p ./.config/

for i in "${files[@]}"
do
    cp -rva ~/$i ./config/
done
