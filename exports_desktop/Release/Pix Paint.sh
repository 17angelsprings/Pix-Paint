#!/bin/sh
echo -ne '\033c\033]0;Pix Paint\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Pix Paint.x86_64" "$@"
