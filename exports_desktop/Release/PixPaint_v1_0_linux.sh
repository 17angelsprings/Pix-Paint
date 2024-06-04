#!/bin/sh
echo -ne '\033c\033]0;Pix Paint\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/PixPaint_v1_0_linux.x86_64" "$@"
