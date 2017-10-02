#!/bin/bash
# convert a folder of numbered docx files and turn it into a folder of url-named directories containing index.html files, itself indexed by an html file

shopt -s nullglob

dir="$1"
if [[ -z $dir ]]; then
	dir="."
fi
dir="$(realpath "$dir")"

basename="$(basename "$dir")"
dirname="$(dirname "$dir")"

printf "# $basename\n\n" > "$dir/index.md"

for i in "$dir"/*; do
	i="$(basename "$i")"
	ext="${i: -4}"
	if [[ ! "$ext" == "docx" ]]; then
		continue
	fi
	number="$(echo "$i" | cut -d ' ' -f 1)"
	link_name="$(echo "${i/.docx/}" | cut -d ' ' -f 1 --complement)"
	link_url="$(echo $link_name | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')"
	new_dir="$dir/$link_url"
	mkdir "$new_dir"
	pandoc "$dir/$i" --extract-media="$new_dir" -s -o "$new_dir/index.html"
	rm "$dir/$i"
	printf -- "$number - [$link_name]($link_url)\n\n" >> "$dir/index.md_tmp"
done
sort -n "$dir/index.md_tmp" | cut -d ' ' -f 1 --complement >> "$dir/index.md"
rm "$dir/index.md_tmp"
pandoc "$dir/index.md" -o "$dir/index.html"
