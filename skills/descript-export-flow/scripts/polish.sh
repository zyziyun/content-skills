#!/usr/bin/env bash
# Polish a Descript-exported vertical short for publishing.
# Usage:
#   polish.sh source.mp4 cover.png final.mp4 [speed_factor]
# Speed factor default 1.2. Pass 1.0 to skip the speed step.
set -euo pipefail

SRC="${1:?source mp4 required}"
COVER="${2:?cover png required}"
FINAL="${3:?final mp4 required}"
SPEED="${4:-1.2}"

TMP_DIR="$(mktemp -d)"
WITHCOVER="$TMP_DIR/with_cover.mp4"
LOUD="$TMP_DIR/with_cover_loud.mp4"

echo ">>> step 1 / 3 — cover replacement"
ffmpeg -y -loglevel error \
  -loop 1 -t 1.0 -i "$COVER" \
  -i "$SRC" \
  -filter_complex "\
    [0:v]scale=1080:1920,setsar=1,fps=30,format=yuv420p[cover];\
    [1:v]trim=start=1.0,setpts=PTS-STARTPTS,scale=1080:1920,setsar=1,fps=30,format=yuv420p[rest];\
    [cover][rest]concat=n=2:v=1:a=0[outv]" \
  -map "[outv]" -map 1:a \
  -c:v libx264 -preset slow -b:v 28M -maxrate 32M -bufsize 64M \
  -pix_fmt yuv420p -movflags +faststart \
  -c:a copy \
  "$WITHCOVER"

echo ">>> step 2 / 3 — loudness normalization to -14 LUFS"
ffmpeg -y -loglevel error -i "$WITHCOVER" \
  -c:v copy \
  -af "loudnorm=I=-14:LRA=11:TP=-1.5" \
  -c:a aac -b:a 192k \
  -movflags +faststart \
  "$LOUD"

if [ "$SPEED" = "1.0" ]; then
  echo ">>> step 3 / 3 — skipping speed (factor 1.0)"
  cp "$LOUD" "$FINAL"
else
  echo ">>> step 3 / 3 — speed up ${SPEED}x"
  ffmpeg -y -loglevel error -i "$LOUD" \
    -filter_complex "[0:v]setpts=PTS/${SPEED}[v];[0:a]atempo=${SPEED}[a]" \
    -map "[v]" -map "[a]" \
    -c:v libx264 -preset slow -b:v 28M -maxrate 32M -bufsize 64M \
    -pix_fmt yuv420p -movflags +faststart \
    -c:a aac -b:a 192k \
    "$FINAL"
fi

rm -rf "$TMP_DIR"

echo ""
echo ">>> done — $FINAL"
ffprobe -v error -show_entries stream=codec_name,width,height,bit_rate,r_frame_rate \
  -show_entries format=duration -of default=noprint_wrappers=1 "$FINAL"
ffmpeg -i "$FINAL" -af "loudnorm=I=-14:print_format=summary" -f null - 2>&1 \
  | grep -E "Input Integrated|Input True Peak" || true
