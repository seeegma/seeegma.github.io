#!/bin/bash
# convert a folder of numbered docx files and turn it into a folder of url-named directories containing index.html files, itself indexed by an html file

shopt -s nullglob

old_dir="$1"
if [[ -z $old_dir ]]; then
	old_dir="."
fi
old_dir="$(realpath "$old_dir")"

old_basename="$(basename "$old_dir")"
old_dirname="$(dirname "$old_dir")"
new_dirname="$old_dirname"
new_basename="$(echo "$old_basename" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g;s/['\'']//g')"
new_dir="$new_dirname/$new_basename"
if [[ "$old_dir" != "$new_dir" ]]; then
	mv "$old_dir" "$new_dir"
fi

printf "# $old_basename\n\n" > "$new_dir/index.md"

for i in "$new_dir"/*; do
	i="$(basename "$i")"
	ext="${i: -4}"
	if [[ ! "$ext" == "docx" ]]; then
		continue
	fi
	number="$(echo "$i" | cut -d ' ' -f 1)"
	link_name="$(echo "${i/.docx/}" | cut -d ' ' -f 1 --complement)"
	link_url="$(echo "$link_name" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g;s/['\''?]//g')"
	out_dir="$new_dir/$link_url"
	# make hubdoc
	mkdir "$out_dir"
	pandoc "$new_dir/$i" --extract-media="$out_dir" >/dev/null
	pandoc "$new_dir/$i" -s -o "$out_dir/index.html"
	rm "$new_dir/$i"
	printf -- "$number - [$link_name]($link_url/index.html)\n\n" >> "$new_dir/index.md_tmp"
done
sort -n "$new_dir/index.md_tmp" | cut -d ' ' -f 1 --complement >> "$new_dir/index.md"
rm "$new_dir/index.md_tmp"
pandoc "$new_dir/index.md" -o "$new_dir/index.html"
# rename directory back to what it was, to preserve the capitalization
if [[ "$old_dir" != "$new_dir" ]]; then
	mv "$new_dir" "$old_dir"
fi
