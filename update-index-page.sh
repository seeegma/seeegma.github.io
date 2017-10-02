#!/bin/bash
# find all docx files recursively in a folder, remove all their sibling files, and run pandoc again

shopt -s nullglob

dir="$1"
if [[ -z $dir ]]; then
	dir="."
fi
dir="$(realpath "$dir")"

for i in "$dir"/*.docx; do
	i="$(basename "$i")"
	new_dir="$dir/$(echo "${i/.docx/}" | cut -d ' ' -f 1 --complement | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')"
	rm -f \"$new_dir\"/*
	pandoc "$dir/$i" --extract-media="$new_dir" -s -o "$new_dir/index.html"
	rm "$dir/$i"
done
