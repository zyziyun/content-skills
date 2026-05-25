---
name: cover-design
description: Build a 1080x1920 vertical cover image for short-form video to replace the dead black first-frame. Two patterns: A) 4-frame diagonal collage of video stills with teal X-slash and center play diamond, or B) 4-slide quadrant background with the speaker's matted face centered on top. Uses HTML + headless Chrome render. Includes Robust Video Matting (RVM) workflow for transparent face extraction on Apple Silicon. Use after a short video is exported but before publishing.
---

# Cover Design

## When to Use

Load this skill when:

- A short video is exported and the first frame is black (Descript Chapter Title default)
- The cover doubles as the social-platform thumbnail (YouTube Shorts, TikTok, Reels, 小红书)
- You want the cover to feel on-brand (black + teal design language) and content-rich (preview what's inside)

Do NOT use for:

- YouTube long-form thumbnails — those are 1280×720 landscape with very different conventions
- Static-image-only posts (use a regular image editor)

## Composes With

- `vertical-slide-design` (uses the same color tokens and rendering pipeline)
- `descript-export-flow` (which has the ffmpeg recipe for replacing the first second with this PNG)

## Two Patterns (pick one per video)

### Pattern A — 4-frame diagonal collage

Use when:
- You want to preview content variety quickly
- The viewer doesn't need to see the speaker's face on the cover (they appear later)
- Bias toward "rich preview" over "personal connection"

Structure:
- 2×2 grid of pre-cropped video stills (slide-only stills, not face stills)
- Two diagonal teal slashes crossing through center
- Black diamond at the intersection with a teal ▶ play glyph
- Small top tag (`● AI · 90 SECONDS`)
- Bottom black-gradient overlay with headline + 3 pills
- Optional corner badges identifying each quadrant (HOOK / PREDICTION / ATTENTION / RECAP)

### Pattern B — Face-centered on quadrant background

Use when:
- The speaker wants their face on the thumbnail (algorithmically often higher CTR)
- You're building a personal brand and recognition matters
- Bias toward "personal connection" over "info density"

Structure:
- 2×2 grid of clean slide PNGs (from `vertical-slide-design`) as background, dimmed to ~55% brightness
- Speaker's face, matted to transparent via RVM, centered, with a teal radial glow halo behind
- Top tag, bottom black-gradient with headline + 3 pills
- Optional corner badges for each background slide

## Constraints

### 1. 1080×1920 exact

Both patterns render to 1080×1920 vertical. No other aspect.

### 2. Use the same design tokens as `vertical-slide-design`

Black `#000`, teal `#2dd4bf`, dim `#9ca3af`, system-ui font. Cover and slides must look like one channel, not two designs.

### 3. Headline is `[Subject] *is/isn't [punch].*` template

Match the channel voice. Examples:

- `ChatGPT *isn't magic.*`
- `Context windows *aren't RAM.*`
- `Refactor *is the most automatable work you do.*`

The `*italic teal*` part is the contrarian punch. Always teal italic.

### 4. Face matting (Pattern B) is non-trivial — do it right

For face matting on Apple Silicon, use **Robust Video Matting (RVM)** via PyTorch hub, MPS backend. Single-frame matting requires warm-up passes (RVM is designed for video, recurrent state).

Why not `rembg`: rembg works but produces softer edges around hair and is slower per-image. RVM with MPS is fast and clean.

### 5. Source the face frame from a "talking" moment, not idle

The best face frames are mid-sentence with mouth slightly open and eyes on camera. Idle frames (eyes drifting, mouth closed) look posed and feel less authentic.

To find the moment: extract every 5-10s from the video, eyeball, pick the one that feels engaged.

### 6. Crop above the burned-in caption strip

If the source video has hardcoded captions (Descript's default), the matting source crop must stop above the caption band. Otherwise the matted PNG will include "modern" or whatever word was on screen.

### 7. Cover replaces only the first 1 second of the video

In `descript-export-flow`, the cover image is shown for 1.0s, then the original video plays from t=1.0. The original audio runs uninterrupted (the first 1s of video had no narration anyway, just black). Total video length is preserved.

## Procedure — Pattern A (Collage)

### Phase 1 — Pick 4 strategic timestamps

From the locked video, pick 4 moments that together preview content variety:

- 1 hook moment (early, title or contrast text visible)
- 2-3 content moments (one per major concept — the bar chart, the attention arrow, the conversation stack)
- 1 face moment (engaged expression)

### Phase 2 — Pre-crop with ffmpeg

Each cell is 540×960 (half of 1080×1920). To show only the slide region of a frame (top half), pre-crop:

```bash
VID=path/to/source.mp4
OUT=cover_src
ffmpeg -y -ss 2.5 -i "$VID" -frames:v 1 \
  -vf "crop=1080:600:0:0,pad=1080:960:0:180:black" \
  "$OUT/q1.png"
# Repeat for q2, q3, q4 at different timestamps
```

`crop=W:H:X:Y` then `pad=W:H:X:Y:color` to standardize to 1080×960 with the content centered.

### Phase 3 — Compose HTML + render

Use `templates/cover_collage.template.html`. Drop the 4 PNGs into `cover_src/`. Render:

```bash
"$CHROME" --headless=new --disable-gpu --hide-scrollbars \
  --window-size=1080,1920 --virtual-time-budget=2000 \
  --screenshot=cover.png \
  "file://$(pwd)/cover.html"
```

## Procedure — Pattern B (Face on Quadrants)

### Phase 1 — Pick the face source frame

Sample frames every 10s from the source video. Pick one where eyes are on camera and mouth is slightly open (mid-word).

### Phase 2 — Crop face region

Source video is 1080×1920. Face region in Descript Chapter Title Split is roughly `y = 960 to y = 1820` (bottom half minus the caption strip). Crop to include face + neck + shoulders + chest top:

```bash
ffmpeg -y -ss 70 -i "$VID" -frames:v 1 \
  -vf "crop=1080:860:0:960" face_src.png
```

### Phase 3 — Matte to transparent

Use `scripts/matte_one.py` (single-frame RVM):

```bash
source .tts-env/bin/activate  # whichever env has torch + opencv
python scripts/matte_one.py face_src.png face_alpha.png
```

If caption is still visible at the bottom of `face_alpha.png`, crop it out in Python:

```python
from PIL import Image
img = Image.open('face_alpha.png').convert('RGBA')
img.crop((0, 0, 1080, 770)).save('face_alpha.png')
```

### Phase 4 — Copy 4 slide PNGs as quadrant background

Use the cleanest 4 slides from `vertical-slide-design` output (title + 3 diagram slides). Copy them as `bg_tl.png`, `bg_tr.png`, `bg_bl.png`, `bg_br.png` in `cover_src/`.

### Phase 5 — Compose HTML + render

Use `templates/cover_face_quadrants.template.html`. The face PNG is the foreground (centered, with teal glow halo). Background grid loads the 4 bg PNGs. Render the same way as Pattern A.

### Phase 6 — Tune face-wrap aspect

**Critical**: the `.face-wrap` width and height must match the face PNG's aspect ratio, or `object-fit:contain` will shrink the face significantly with empty space.

If your face PNG is 1080×770 (aspect 1.40), use `.face-wrap { width: 980px; height: 700px; }` — same aspect. Adjust per cover.

## Output Template (contract)

One file:

```
~/Desktop/cover.png    (1080×1920, ~500-800 KB)
```

Plus reusable working files:

```
content-skills/skills/cover-design/output/
├── cover.html
├── cover_src/
│   ├── q1.png .. q4.png   (Pattern A) or
│   ├── bg_tl.png .. bg_br.png + face_alpha.png   (Pattern B)
└── cover.png
```

## Self-check

- [ ] 1080×1920 exact resolution
- [ ] Black background, teal accent (#2dd4bf)
- [ ] Headline uses `Subject *isn't magic.*` template with teal italic punch
- [ ] If Pattern B: face is matted cleanly (no halo, no caption strip)
- [ ] If Pattern B: face-wrap aspect matches PNG aspect (no shrinking)
- [ ] Each quadrant shows distinct content (not 4 near-identical frames)
- [ ] Top tag and bottom headline don't overlap with focal content
- [ ] PNG opens cleanly in QuickLook (no broken transparency, no oversaturation)

## Reference implementations

- `templates/cover_collage.template.html` — Pattern A
- `templates/cover_face_quadrants.template.html` — Pattern B
- `scripts/matte_one.py` — single-frame RVM matting
- `scripts/extract_collage_frames.sh` — ffmpeg pre-crop for Pattern A

## Known pitfall — wrong video dimensions

Apple's `ffprobe` sometimes reports a video as `720×1280` when the actual rendered frames are `1080×1920`. Always extract one frame and check dimensions before computing crop coordinates:

```bash
ffmpeg -y -ss 1 -i "$VID" -frames:v 1 /tmp/check.png
python3 -c "from PIL import Image; print(Image.open('/tmp/check.png').size)"
```

The Python check is ground truth. Trust it over ffprobe stream metadata.
