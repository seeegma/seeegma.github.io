#!/bin/bash

old_file="$1"
old_basename="$(basename "$old_file")"
old_dirname="$(dirname "$old_file")"

new_dirname="$old_dirname/$(echo "${old_basename/.docx/}" | cut -d ' ' -f 1 --complement | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')"
new_basename="index.html"
new_file="$new_dirname/$new_basename"

# make dir
mkdir "$new_dirname"
# extract media
pandoc "$old_file" --extract-media="$new_dirname" >/dev/null
# convert to html
pandoc "$old_file" -s -o "$new_file"
rm "$old_file"
