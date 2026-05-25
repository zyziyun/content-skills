# SOP — Publish a Short Video, End to End

Standard operating procedure for going from a topic idea to a published vertical short on TikTok / YouTube Shorts / Reels / 小红书. ~3-4 hours from start to finish for the first one, ~90 minutes once the workflow is fluent.

## Objective

Take one topic idea (~1 sentence) and produce:

1. A locked English script (~90s of spoken content)
2. A drilled pronunciation reference for the narrator
3. 10-15 vertical slides
4. A recorded talking-head video in Descript
5. A polished MP4 with cover, loudnorm, and speed-up
6. Published versions on at least 2 platforms

## Constraints

- **One video per session.** Don't try to batch-produce. Each video deserves the focused attention.
- **Lock the script before recording.** Don't iterate the script during recording — that's how 4-hour sessions become 8.
- **Production friction is the enemy.** If a phase takes longer than its budget, ship the rough version and improve next time. Don't perfect.
- **No vertical-video creative work after 9pm.** Tired-brain video work always looks worse than morning work, and you can't tell until tomorrow.

## Phase 1 — Topic & Premise (15 min)

Before writing any script:

1. Write the topic in 1 sentence
2. Answer these 4 questions in 1-2 sentences each:
   - What's the ONE thing the viewer should walk away knowing?
   - What does the viewer already (wrongly) believe about this?
   - What's the concrete action / mental tool they should keep?
   - Why do I find this interesting? (This informs voice, not the script itself)

If you can't answer #1 in 15 words, the topic isn't ready. Pick another.

## Phase 2 — Draft script (45 min)

Load skill: `script-voice` (self-contained, no longer needs `video-script-writing`).

1. Structure: hook (3 sentences) → walk-through → 干货 insight → closing
2. Draft in continuous prose, no fragments, no em-dashes
3. Target word count: 165-250 for 60-90s, 250-330 for 90-120s
4. Write the hook **last**, not first — you can only hook well when you know what you're hooking into

## Phase 3 — Read-aloud pass (15 min)

This is non-negotiable. Read the entire script aloud, performance voice.

Listen for:

- Sentences that trip the tongue → rewrite
- Bullet structures in disguise → connect with prose
- AI-tell vocabulary (`delve`, `leverage`, `comprehensive`) → replace
- Doubled definitions → keep one
- Forward references (`we'll cover this later`) → delete
- Filler reassurance (`this might sound complex`) → delete

Run the `script-voice` self-check before locking.

## Phase 4 — Pronunciation drill (15 min)

Load skill: `pronunciation-drill`.

1. Read the locked script, mark every word that trips you
2. Cut to 8 words (10 max)
3. Generate the drill audio
4. Practice it 2-3 times before recording

## Phase 5 — Slide design (60 min)

Load skill: `vertical-slide-design`.

1. Plan slide breakpoints in the script (target: 1 slide per 6-10s of spoken script)
2. Edit `slides_vertical.template.html` — swap content per slide
3. Preview in browser, verify each slide fits at 1080×1080
4. Batch-render all PNGs
5. For 2-3 high-value diagrams, also render animated MP4s

## Phase 6 — Record in Descript (45 min)

1. Open Descript, create a new vertical (9:16) project
2. Layout: **Chapter Title Split Screen**
3. Record the talking-head pass (raw, single take if possible)
4. Use Descript's filler-word removal
5. Drop slide PNGs / MP4s into the slide region at the right timestamps
6. Generate auto-captions (Descript does this well)
7. Style the captions: yellow text + black stroke, 4-5 words per line, positioned at bottom

## Phase 7 — Export from Descript (5 min)

Settings:

- Resolution: 1080×1920
- Frame rate: 30fps
- Quality: High
- Captions: **None** (export burned-in version OR a separate .srt — don't double-up later)
- Audio: AAC 192kbps

Output to `~/Desktop/raw_export.mp4`.

## Phase 8 — Cover design (30 min)

Load skill: `cover-design`.

Decide pattern A (4-frame collage) or B (face on quadrants). For first videos, pattern B builds personal recognition; for established channels, pattern A is more "content density".

Produce `~/Desktop/cover.png` at 1080×1920.

## Phase 9 — Polish (5 min)

Load skill: `descript-export-flow`.

```bash
~/Desktop/content-skills/skills/descript-export-flow/scripts/polish.sh \
  ~/Desktop/raw_export.mp4 \
  ~/Desktop/cover.png \
  ~/Desktop/final.mp4 \
  1.2
```

Verify the output passes the self-check.

## Phase 10 — Publish (30 min)

Upload `final.mp4` to each platform:

| Platform | Cover override | Caption | Hashtags |
|---|---|---|---|
| **YouTube Shorts** | Upload `cover.png` as custom thumbnail | Hook line + 1 supporting sentence | 0-2 only |
| **TikTok** | "Select cover" → "Upload" → cover.png | Hook line | 3-5, niche-relevant |
| **Instagram Reels** | "Cover" → "Add from camera roll" → cover.png | Hook line | 3-5 |
| **小红书** | Custom cover → cover.png | 钩子标题 + 正文展开 + emoji 分段 | 3-5 tags, 中文 |

After upload, check that the published cover image actually rendered (some platforms occasionally swap to a video frame).

## Phase 11 — Inventory next idea (10 min)

The first 5 minutes of momentum after publishing are when you have the most enthusiasm for the next one. Use them:

1. Write down 3 candidate topics for the next video
2. Pick the strongest, write the 1-sentence premise
3. Schedule a Phase 1-2 session for tomorrow

## Failure modes & recovery

| Symptom | Likely cause | Fix |
|---|---|---|
| Final video feels boring | Pace too slow, no animation, no BGM | Re-do with BGM at -28dB, add 1-2 animated MP4 slides |
| Audio sounds quiet on phone | Loudnorm step skipped or wrong target | Re-run polish.sh, verify -14 LUFS |
| Cover looks off-brand | Used wrong template / wrong accent color | Re-render with `vertical-slide-design` design tokens |
| Captions out of sync | Speed step applied after Descript's burned-in captions | Re-export from Descript without captions, then polish |
| TikTok cover shows random frame | Forgot to upload custom cover at publish time | Edit post → reset cover → upload `cover.png` |
| YouTube Shorts not appearing in feed | Length > 3 min, or upload didn't tag as Short | Confirm length ≤ 180s; aspect 9:16 |

## Time budget total

| Phase | Budget |
|---|---|
| 1. Premise | 15 min |
| 2. Draft | 45 min |
| 3. Read-aloud | 15 min |
| 4. Drill | 15 min |
| 5. Slides | 60 min |
| 6. Record | 45 min |
| 7. Export | 5 min |
| 8. Cover | 30 min |
| 9. Polish | 5 min |
| 10. Publish | 30 min |
| 11. Next idea | 10 min |
| **Total** | **~4.5 hours** |

After the third video, expect this to drop to ~2 hours because phases 5 (slides) and 8 (cover) become template swaps.

## Output template (contract)

A successful run produces these files, organized:

```
~/Desktop/short_NNN_topic_slug/
├── script.md                   # locked script
├── pronunciation_drill.m4a     # drill audio
├── pronunciation_drill.md      # drill reference
├── slides/
│   ├── slide_01_*.png .. slide_15_*.png
│   └── slide_06_paris.mp4 (optional animations)
├── raw_export.mp4              # Descript export
├── cover.png                   # 1080×1920 cover
└── final.mp4                   # publish-ready
```

And published versions on at least YouTube Shorts + 1 other platform within 24h of finishing the polish step.
