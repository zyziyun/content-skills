#!/usr/bin/env bash
# Extract 4 pre-cropped collage frames from a vertical short video.
# Usage: extract_collage_frames.sh source.mp4 out_dir t1 t2 t3 t4
set -euo pipefail
VID="${1:?need source mp4}"
OUT="${2:?need output dir}"
T1="${3:-2.5}"
T2="${4:-37}"
T3="${5:-76}"
T4="${6:-80}"
mkdir -p "$OUT"

# Slide region — top half with letterbox padding to 1080x960
ffmpeg -y -ss "$T1" -i "$VID" -frames:v 1 -vf "crop=1080:600:0:0,pad=1080:960:0:180:black" "$OUT/q1.png" -loglevel error
ffmpeg -y -ss "$T2" -i "$VID" -frames:v 1 -vf "crop=1080:600:0:0,pad=1080:960:0:180:black" "$OUT/q2.png" -loglevel error
ffmpeg -y -ss "$T3" -i "$VID" -frames:v 1 -vf "crop=1080:600:0:0,pad=1080:960:0:180:black" "$OUT/q3.png" -loglevel error
# Last one is face region (bottom half)
ffmpeg -y -ss "$T4" -i "$VID" -frames:v 1 -vf "crop=1080:800:0:960,pad=1080:960:0:80:black" "$OUT/q4.png" -loglevel error
echo "wrote 4 frames to $OUT/"
