#!/bin/sh
echo "Copying $1 to $2 with $3 quality"
convert -quality $3 "$1" "$2"
wc -c $2 
