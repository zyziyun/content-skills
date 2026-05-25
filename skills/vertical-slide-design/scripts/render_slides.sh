#!/usr/bin/env bash
# Batch render slides to PNG via headless Chrome.
# Usage: ./render_slides.sh path/to/slides.html /path/to/output/dir
set -euo pipefail

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
HTML="${1:?usage: render_slides.sh slides.html out_dir [key1 key2 ...]}"
OUT="${2:?need output dir}"
shift 2

# Discover keys from HTML if not provided
if [ "$#" -eq 0 ]; then
  KEYS=$(grep -oE 'data-key="[^"]+"' "$HTML" | sed 's/data-key="//;s/"//')
else
  KEYS="$@"
fi

mkdir -p "$OUT"
URL="file://$(cd "$(dirname "$HTML")" && pwd)/$(basename "$HTML")"

for key in $KEYS; do
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars \
    --window-size=1080,1080 --virtual-time-budget=1500 \
    --screenshot="$OUT/slide_${key}.png" \
    "${URL}?export=${key}" 2>&1 | tail -1
done
