---
name: pronunciation-drill
description: Generate a shadowing-practice audio file from a list of 5-10 pitfall words plus their source-script sentences, using Kokoro TTS via mlx-audio on Apple Silicon. Produces a single drill WAV/M4A with each word read slowly twice, then the sentence at near-normal pace, separated by silences sized for the listener to repeat. Use after a script is locked, when the narrator wants to drill specific words before recording. Output is loudnorm-ready and includes a markdown reference with IPA, the pitfall, and the source sentence.
---

# Pronunciation Drill

## When to Use

Load this skill when:

- A video script is locked and the narrator wants to practice difficult words before recording
- The narrator has a non-native accent and specific words trip them up
- The script contains 5-10 high-frequency or high-stakes words that get mispronounced

Do NOT load for:

- General English pronunciation tutoring (this is script-specific, not curriculum)
- Words that don't appear in the actual script (no value)
- More than ~12 words at once (drill becomes too long; split into two skills)

## Composes With

- `script-voice` — run this after the script is finalized
- `descript-export-flow` — drill audio is separate from the final video pipeline

## Constraints

### 1. Word list comes from the actual script

Every word in the drill must appear in the locked script. No "general useful words." Practice has to map directly to what they're about to record.

### 2. Each entry has both a slow word and a script sentence

The drill loop per word is **always** `[slow word] → silence → [slow word] → silence → [normal sentence] → long silence`. Don't deviate.

### 3. Use the same voice as the rest of the workflow

Default: `af_heart` (Kokoro 82M). This keeps the narrator's reference voice consistent across drill, captions check, and any TTS preview.

### 4. Output is loudnorm-ready

The final M4A should be at -14 LUFS so the narrator can drop it into AirPods at the same volume as anything else they're listening to. No raw Kokoro output.

## Procedure

### Phase 1 — Pick the words (5 min, manual)

1. Read the script aloud once.
2. Mark every word where you stumble or where the IPA isn't obvious.
3. Cut to **8 words** (sweet spot — 10 max). Prioritize: high frequency in script > high cultural visibility > high pitfall potential.
4. For each, write down: the word, its IPA (look up if unsure), the 1-line pitfall, and the source sentence from the script.

### Phase 2 — Generate clips (5 min, automated)

Use `scripts/make_drill.py`. For each word, generate two clips with mlx-audio:

```python
kokoro(text=f"{word}.", speed=0.65, prefix=f"w{i:02d}_slow")
kokoro(text=sentence,    speed=0.85, prefix=f"w{i:02d}_sent")
```

Speeds are tuned: 0.65 is slow enough to hear every phoneme, 0.85 is near-normal but with breathing room for a learner.

### Phase 3 — Generate silences

Two silence files via `anullsrc`:

- `sil_short.wav` — 1.2 seconds (between the two slow-word repetitions, and between slow-word and sentence)
- `sil_long.wav` — 2.2 seconds (after the sentence, for the user to repeat in full)

Match Kokoro's output sample rate (24 kHz mono).

### Phase 4 — Assemble

Use ffmpeg concat demuxer with a per-line file list:

```
file 'intro.wav'
file 'sil_long.wav'
file 'w00_slow.wav'
file 'sil_short.wav'
file 'w00_slow.wav'
file 'sil_short.wav'
file 'w00_sent.wav'
file 'sil_long.wav'
... (repeat for each word)
```

Then `ffmpeg -f concat -safe 0 -i concat.txt -c copy out.wav`.

### Phase 5 — Loudnorm + M4A

```bash
ffmpeg -y -i out.wav \
  -af "loudnorm=I=-14:LRA=11:TP=-1.5" \
  -c:a aac -b:a 128k drill.m4a
```

### Phase 6 — Write the markdown reference

For each word, output:

```markdown
## N. {word}  {IPA}

**Pitfall**: {one-line explanation}

BAD:  {wrong way}
GOOD: {right way}

**Sentence**: *{source sentence from script}*
```

## Output Template (contract)

Two files:

1. `pronunciation_drill.m4a` (or `.wav`) — the audio
2. `pronunciation_drill.md` — the reference card

Audio structure, deterministic per word:

```
[intro line spoken] → [2.2s silence]
  ↓ for each word ↓
[slow word]  → [1.2s] → [slow word]  → [1.2s] → [normal sentence] → [2.2s]
```

Total length formula: `intro (≈4s) + 2.2 + n × (≈1 + 1.2 + 1 + 1.2 + ≈3 + 2.2)` ≈ `~6 + n × 9.6` seconds.

For 8 words: ~83 seconds. (Real ones land 100-115s with Kokoro's natural pacing.)

## Reference implementation

See `scripts/make_drill.py` for the working Python that generates everything in one pass. Run with:

```bash
source /Users/ziyun/Desktop/.tts-env/bin/activate
python content-skills/scripts/make_drill.py
```

Outputs to `~/Desktop/pronunciation_drill.{wav,m4a,md}` by default; edit the `OUT_*` paths to change.

## Self-check

- [ ] Every word in the drill appears in the locked script
- [ ] 5-10 words total (not more)
- [ ] Each word has IPA + pitfall + source sentence
- [ ] Audio loudnormed to -14 LUFS
- [ ] M4A size under 1 MB (if larger, check sample rate / bitrate)
- [ ] Markdown reference written next to the audio file
