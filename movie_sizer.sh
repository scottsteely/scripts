#!/bin/sh

movie_dir=/mnt/share/Movies/Movies/

while read movie_name; do
	search_here="$movie_dir""$movie_name""/"
	find "$search_here" -printf '%s %p\n' | sort -nr | head -1
done </home/scott/temp/list.txt

