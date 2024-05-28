#!/bin/sh
echo -ne '\033c\033]0;Pix Paint\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/PixPaint_0_3_5_linux.x86_64" "$@"
