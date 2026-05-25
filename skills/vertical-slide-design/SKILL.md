---
name: vertical-slide-design
description: Build 1080x1080 square slides for vertical short-form video (TikTok / YouTube Shorts / Reels / 小红书) using a single HTML file rendered to PNG via headless Chrome. Black background, teal #2dd4bf accent, system-ui typography, slide-per-section structure activated via URL query param. Optional Playwright pipeline for recording slides with CSS animations as MP4 clips. Use when a locked script needs 10-15 visual slides that will be dropped into Descript or CapCut between talking-head footage.
---

# Vertical Slide Design

## When to Use

Load this skill when:

- A short-video script is locked and needs visual slides to pair with talking-head footage
- The slides will be placed in Descript's Chapter Title Split layout (or CapCut equivalent), where they occupy roughly the top half of a 9:16 frame
- You want 10-15 slides for a 60-180s video (~6-12s per slide)

Do NOT use for:

- Landscape 16:9 slides (different aspect, different template)
- Slides that need to be edited interactively (use Keynote / Figma)
- Long-form YouTube where slides are full-screen (use 1920x1080 instead)

## Composes With

- `script-voice` (parent of the script being illustrated)
- `cover-design` (uses the same HTML+headless Chrome rendering pipeline)

## Design Language (do not deviate)

These are locked across the whole channel for visual identity:

| Token | Value |
|---|---|
| Background | `#000` (pure black) |
| Primary text | `#fff` |
| Dim text | `#9ca3af` (gray-400) |
| Accent | `#2dd4bf` (teal-400) |
| Accent soft | `rgba(45,212,191,.16)` |
| Font | `-apple-system, "SF Pro Display", "Segoe UI", system-ui, sans-serif` |
| Viewport | **1080 × 1080** square |

Why square: Descript's Chapter Title Split puts slides in a region that's roughly square. Square renders without crop in that region, and degrades gracefully if the layout shifts to 4:5 or 1:1.

## Constraints

### 1. One HTML file, all slides in it

All slides live in a single `slides_vertical.html` as `<section class="slide" data-key="...">` blocks. Selected via `?export=<key>` URL parameter.

Don't create one HTML per slide. The single-file approach makes the design-language tokens reusable and lets the dev preview keyboard-navigate (1/2/3/...).

### 2. Every slide is `position: absolute; inset: 0` and shown via `.on` class

```css
.slide{
  position:absolute;inset:0;
  display:none;
  flex-direction:column;align-items:center;justify-content:center;
  padding:60px;text-align:center;
}
.slide.on{ display:flex; }
```

Don't use `display:none/block` for visibility, use the class — it composes with animations.

### 3. CSS `var(--xxx)` does NOT interpolate in `@keyframes`

This is a real pitfall from a real revision. If you do:

```css
body.animate .fill{ animation: grow 1s forwards; }
@keyframes grow{ to{ width: var(--tgt); } }
```

The width will **not** animate. It will jump or do nothing. Use explicit values:

```css
body.animate .bar.top .fill{ animation: gParis 1.1s both; }
@keyframes gParis{ from{ width:0; } to{ width:87%; } }
```

Always use `from` + `to`, and `both` for fill-mode (pins both ends).

### 4. Sentence-style text never wraps

For example slides that hold a sentence like `"the cat sat on the mat because it was tired"`, use `white-space:nowrap` and tune the font-size so it fits at 1080 wide minus padding. If it wraps to 2 lines, attention arrows and other geometric overlays will break.

### 5. No emojis in heading text

Emojis are OK in body text (e.g., chat-bubble examples). Not in headings. They render inconsistently across rendering engines.

### 6. Eyebrow tag pattern is standard

If a slide has a section identifier, use this:

```html
<div class="eyebrow"><span class="dot"></span>SECTION NAME</div>
```

```css
.eyebrow{
  color:var(--teal);font-size:28px;letter-spacing:.32em;
  text-transform:uppercase;font-weight:600;margin-bottom:24px;
}
.eyebrow .dot{
  display:inline-block;width:8px;height:8px;border-radius:50%;
  background:var(--teal);margin:0 14px;vertical-align:4px;
}
```

## Procedure

### Phase 1 — Slide plan (10 min)

From the locked script, pick the slide breakpoints. Target: every 6-12 seconds = one slide.

A typical 90-second short = 10-14 slides. Structure:

| Slide # | Type | Purpose |
|---|---|---|
| 01 | Hook title | The big headline of the video |
| 02 | Contrast / hook setup | Visualize the misconception or "you" framing |
| 03 | Preview / outline | Optional — list the 3 things if it's a list video |
| 04, 08, 11 | Section headers | Big number + word (1 LLM / 2 Transformer / 3 Context) |
| 05, 09, 12 | Concept punchlines | One big sentence per major idea |
| 06, 10, 13 | Diagrams | Bar chart / arrows / stack — the visual proof |
| 07 | Internal punchline | The "so what" of a section |
| Last | Outro / CTA | Recap + question for comments |

### Phase 2 — Write the HTML

Use `templates/slides_vertical.template.html` as the starting point. For each slide:

1. Add a `<section class="slide" data-key="NN_descriptive_name">` block
2. Pick a style class from existing presets: `s-title`, `s-contrast`, `s-three`, `s-sec` (section header), `s-punch`, `s-bars`, `s-attn`, `s-ctx` (stack), `s-nomem` (giant single word), `s-recap`, `s-outro`
3. Fill in content

The presets cover ~90% of slide needs. Only add new style classes if a slide is genuinely structural-new.

### Phase 3 — Preview in browser

Open the file in Chrome. Press `1`-`9`, `0`, `q-t` to switch between slides interactively. Verify each slide:

- Content is centered
- No text overflow at 1080×1080
- Teal accent is visible
- For diagrams, the geometry doesn't break (arrows hit their targets, bars span correctly)

### Phase 4 — Batch render to PNG

```bash
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
URL="file:///path/to/slides_vertical.html"
OUT=/path/to/output/dir

KEYS=(01_title 02_contrast 03_three 04_llm_sec 05_llm_predict 06_paris 07_llm_punch 08_tf_sec 09_attn 10_tf_punch 11_ctx_sec 12_nomem 13_resend 14_recap 15_outro)

for key in "${KEYS[@]}"; do
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars \
    --window-size=1080,1080 --virtual-time-budget=1500 \
    --screenshot="$OUT/slide_${key}.png" \
    "${URL}?export=${key}"
done
```

`--virtual-time-budget=1500` gives 1.5s for any JS (like SVG-drawing for attention arrows) to settle before screenshotting.

### Phase 5 (optional) — Animated MP4s for diagram slides

For the 2-3 slides where motion *is* the explanation (bars growing, arrows drawing, stack building), render as MP4 instead of PNG. Use Playwright with `record_video_dir`:

```python
async def record_one(p, key, duration):
    browser = await p.chromium.launch()
    context = await browser.new_context(
        viewport={"width":1080,"height":1080},
        record_video_dir=str(workdir),
        record_video_size={"width":1080,"height":1080})
    page = await context.new_page()
    await page.goto(f"{URL}?export={key}&animate=1")
    await page.wait_for_timeout(int(duration * 1000))
    await context.close()
    await browser.close()
```

Then ffmpeg-convert the webm to h.264 mp4:

```bash
ffmpeg -y -i record.webm \
  -c:v libx264 -pix_fmt yuv420p -crf 18 -preset slow \
  -movflags +faststart out.mp4
```

Recommendation: animate **at most 3 slides per video**. Animating everything dilutes the impact and makes the video feel restless.

### Phase 6 — Import into Descript / CapCut

For each script section, drag the matching PNG (or MP4) onto the timeline at the right timestamp. The slide region in the chosen layout will display it directly.

## Output Template (contract)

A successful run produces:

```
slides_vertical/
├── slide_01_title.png
├── slide_02_contrast.png
├── ...
└── slide_15_outro.png
```

Optionally:

```
slide_06_paris.mp4    (animated, ~3.4s)
slide_09_attn.mp4     (animated, ~3.9s)
slide_13_resend.mp4   (animated, ~4.2s)
```

Each PNG is 1080×1080. Each MP4 is 1080×1080 @ 25fps, h264 yuv420p, CRF 18.

## Reference implementations

- `templates/slides_vertical.template.html` — the canonical starting HTML
- `scripts/render_slides.sh` — batch PNG render
- `scripts/record_slides_anim.py` — Playwright video recorder

## Self-check

- [ ] All slides are 1080×1080
- [ ] No text overflows the viewport at any slide
- [ ] Eyebrow tags use the standard pattern (color, letterspacing, dot)
- [ ] Section headers use the giant-teal-number pattern (slides 04/08/11 in the standard structure)
- [ ] Diagrams use `from`+`to` keyframes for any width/transform animation
- [ ] No `var(--xxx)` inside `@keyframes` interpolated values
- [ ] If animated MP4, narrator's voiceover for that section is at least as long as the animation (so animation doesn't repeat before voice catches up)
- [ ] All PNGs/MP4s named with `slide_NN_descriptive.{png,mp4}` for deterministic timeline order
