#!/bin/bash

shopt -s nullglob

dir="$1"
if [[ -z $dir ]]; then
	dir="."
fi
dir="$(realpath "$dir")"

basename_title="$(basename "$dir")"
dirname="$(dirname "$dir")"

rm -f "$dir/index.md"
printf "# $basename_title\n\n" >> "$dir/index.md"
for i in "$dir"/*.{jpg,JPG}; do
	pic_name="$(basename "$i")"
	printf "![${pic_name:0:-4}]($pic_name)\n\n" >> "$dir/index.md"
done
pandoc "$dir/index.md" -o "$dir/index.html"

dir_url="$dirname/$(echo $basename_title | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')"
mv "$dir" "$dir_url"
