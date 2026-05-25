---
name: descript-export-flow
description: Polish a Descript-exported MP4 for short-form platforms in three deterministic ffmpeg steps - cover-image replacement of the first second, loudness normalization to -14 LUFS (TikTok / YouTube / Instagram standard), and optional 1.2x speed-up with pitch preservation. Preserves original resolution (1080x1920), frame rate (30fps), and uses bitrate targeting to match source quality (~28 Mbps). Use after Descript export and after cover-design produces a 1080x1920 cover.png.
---

# Descript Export Flow

## When to Use

Load this skill when:

- You just exported a vertical short from Descript and need to publish-ready it
- The first frame is black (Descript Chapter Title default) and needs to be replaced with a real cover
- The audio sounds quiet (Descript exports often land around -21 LUFS, well below the -14 LUFS platform target)
- The script reads slightly slowly and you want a 1.2x speed bump to land in the short-video pacing sweet spot

Do NOT use for:

- Long-form YouTube — those have different loudness targets (-14 LUFS works but the speed-up step usually doesn't)
- Files you haven't seen / measured — always probe first, don't blindly apply

## Composes With

- `cover-design` (provides the `cover.png` consumed in step 1)
- `script-voice` and `pronunciation-drill` are upstream (script → audio); this skill is downstream (mp4 → publish)

## Constraints

### 1. One step per ffmpeg invocation

Don't try to do cover + loudnorm + speed in a single complex filter chain. Three sequential files is way easier to debug and verify. Disk is cheap, your time isn't.

### 2. Preserve original resolution and frame rate

Source is 1080×1920 @ 30fps. Output stays 1080×1920 @ 30fps. Never downscale "to save bandwidth" — platforms re-encode, you only lose quality.

### 3. Match source bitrate when re-encoding

If source is ~28 Mbps, output target is 28 Mbps. Don't let `libx264 -crf 18` decide for you — it'll go 4-6 Mbps which is fine for re-upload but **not** archival-quality. Use explicit `-b:v 28M -maxrate 32M -bufsize 64M`.

### 4. Loudnorm target is -14 LUFS

TikTok, YouTube, Instagram, Spotify all target -14 LUFS integrated. True Peak ceiling -1.5 dBTP avoids platform clipping. LRA (loudness range) 11 is the standard for spoken content.

Don't normalize again after this step — platforms will normalize on upload, second pass is wasted.

### 5. Speed-up uses `atempo`, not `asetrate`

`atempo` preserves pitch. `asetrate` changes pitch (chipmunk voice). Always `atempo` for speech.

For factors above 2.0, chain: `atempo=2.0,atempo=1.5` for 3.0x. For 1.2x just `atempo=1.2`.

### 6. Cover replacement preserves total length and audio timing

The cover image is shown for the first 1.0 second. The original video is trimmed to start at t=1.0. Audio plays from the original at full length (no trim). This keeps audio in sync with the video that follows the cover, and the first second of audio (which is just black-frame silence in Descript) plays under the cover image. Total length = original total length.

## Procedure

### Step 1 — Replace first second with cover

```bash
SRC="path/to/descript_export.mp4"
COVER="path/to/cover.png"   # from cover-design skill
OUT="path/to/with_cover.mp4"

ffmpeg -y \
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
  "$OUT"
```

Why this works:

- `-loop 1 -t 1.0 -i cover.png` creates a 1-second video loop of the cover
- `[1:v]trim=start=1.0,setpts=PTS-STARTPTS` strips the first second off the source video
- `concat=n=2:v=1:a=0` joins the two video segments; audio is mapped from source 1 at full length
- `-c:a copy` keeps the audio stream unchanged for now (loudnorm comes next)

### Step 2 — Loudness normalization

First, measure:

```bash
ffmpeg -i "$WITHCOVER" -af "loudnorm=I=-14:print_format=summary" -f null - 2>&1 \
  | grep -E "Input Integrated|Input True Peak"
```

This prints something like `Input Integrated: -21.3 LUFS`. If it's already between -15 and -13 LUFS, skip this step. Otherwise apply:

```bash
ffmpeg -y -i "$WITHCOVER" \
  -c:v copy \
  -af "loudnorm=I=-14:LRA=11:TP=-1.5" \
  -c:a aac -b:a 192k \
  -movflags +faststart \
  "$LOUD"
```

`-c:v copy` is fast — only audio is re-encoded.

Verify:

```bash
ffmpeg -i "$LOUD" -af "loudnorm=I=-14:print_format=summary" -f null - 2>&1 \
  | grep -E "Input Integrated"
# Expect: Input Integrated: -14.X LUFS
```

### Step 3 — Speed-up (optional, 1.2x recommended for short-form)

```bash
ffmpeg -y -i "$LOUD" \
  -filter_complex "[0:v]setpts=PTS/1.2[v];[0:a]atempo=1.2[a]" \
  -map "[v]" -map "[a]" \
  -c:v libx264 -preset slow -b:v 28M -maxrate 32M -bufsize 64M \
  -pix_fmt yuv420p -movflags +faststart \
  -c:a aac -b:a 192k \
  "$FINAL"
```

After 1.2x, a 2:03 video becomes ~1:43. This lands in the short-video pacing sweet spot.

Don't go above 1.3x — speech intelligibility drops and Kokoro / human voices both start sounding artificial.

## Output Template (contract)

Three intermediate files plus one final:

```
descript_export.mp4               (original from Descript)
  → with_cover.mp4                (step 1 — cover replaced)
  → with_cover_loud.mp4           (step 2 — loudnormed)
  → final.mp4                     (step 3 — sped up, ready to publish)
```

Final file properties:

| | Value |
|---|---|
| Resolution | 1080×1920 |
| Frame rate | 30fps |
| Video codec | h264 yuv420p |
| Video bitrate | ~28 Mbps |
| Audio codec | aac 192kbps |
| Loudness | -14 LUFS integrated |
| Length | original length ÷ 1.2 (if step 3 applied) |

## Verification commands

```bash
# Probe everything in one shot
ffprobe -v error -show_entries stream=codec_name,width,height,bit_rate,r_frame_rate \
  -show_entries format=duration -of default=noprint_wrappers=1 final.mp4

# Verify first frame is the cover
ffmpeg -y -ss 0.3 -i final.mp4 -frames:v 1 /tmp/verify_first.png
qlmanage -p /tmp/verify_first.png 2>/dev/null

# Verify loudness
ffmpeg -i final.mp4 -af "loudnorm=I=-14:print_format=summary" -f null - 2>&1 \
  | grep Integrated
```

## Self-check

- [ ] Final file is 1080×1920 @ 30fps
- [ ] Video bitrate ≥ 25 Mbps (close to source's 28 Mbps)
- [ ] Loudness within -15 to -13 LUFS
- [ ] True Peak ≤ -1.0 dBTP (no clipping)
- [ ] First frame is the cover image, not black
- [ ] Audio at frame 0 matches audio at frame 0 of original (cover overlay doesn't shift audio)
- [ ] Total length = original ÷ speed factor (within 0.5s tolerance)

## Reference implementation

`scripts/polish.sh` — runs all 3 steps with sensible defaults:

```bash
./scripts/polish.sh source.mp4 cover.png final.mp4 [speed_factor]
```

Defaults to 1.2x speed if `speed_factor` omitted. Skip a step by passing `--skip-cover`, `--skip-loud`, or `--skip-speed`.
