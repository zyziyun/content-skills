"""Generate a shadowing/pronunciation drill audio file with Kokoro.

For each word:
  [slow word] (1.2s gap) [slow word again] (1.2s gap) [script sentence at slightly slow] (2.5s gap for user repeat)
"""
import subprocess, shutil
from pathlib import Path

WORDS = [
    {"w":"LLM",          "sent":"LLM. Large Language Model."},
    {"w":"Transformer",  "sent":"The Transformer is the engine inside the LLM."},
    {"w":"attention",    "sent":"That's called attention, and every modern AI uses it."},
    {"w":"context",      "sent":"Last word, context."},
    {"w":"autocomplete", "sent":"ChatGPT is basically autocomplete on steroids."},
    {"w":"steroids",     "sent":"ChatGPT is basically autocomplete on steroids."},
    {"w":"bundle",       "sent":"That bundle is the context."},
    {"w":"conversation", "sent":"The app re-sends your entire conversation from scratch."},
]

CLIPS = Path("/tmp/drill_clips")
if CLIPS.exists(): shutil.rmtree(CLIPS)
CLIPS.mkdir()
MODEL = "mlx-community/Kokoro-82M-bf16"
VOICE = "af_heart"

def kokoro(text, speed, prefix):
    subprocess.run([
        "python","-m","mlx_audio.tts.generate",
        "--model", MODEL, "--text", text,
        "--voice", VOICE, "--speed", str(speed),
        "--join_audio", "--audio_format", "wav",
        "--output_path", str(CLIPS), "--file_prefix", prefix
    ], check=True, capture_output=True)
    return CLIPS / f"{prefix}.wav"

def silence(seconds, path):
    subprocess.run([
        "ffmpeg","-y","-loglevel","error",
        "-f","lavfi","-i","anullsrc=channel_layout=mono:sample_rate=24000",
        "-t", str(seconds), str(path)
    ], check=True)

# 1. Generate slow words + sentences
print("generating clips…", flush=True)
for i, item in enumerate(WORDS):
    w, sent = item["w"], item["sent"]
    print(f"  [{i+1}/{len(WORDS)}] {w}", flush=True)
    kokoro(f"{w}.", 0.65, f"w{i:02d}_slow")
    kokoro(sent,    0.85, f"w{i:02d}_sent")

# 2. Generate silence clips
silence(1.2, CLIPS/"sil_short.wav")
silence(2.2, CLIPS/"sil_long.wav")
silence(0.8, CLIPS/"sil_intro.wav")

# 3. Build concat list
intro_text = "Pronunciation drill. Eight words. Repeat after each one."
kokoro(intro_text, 0.85, "intro")

concat_list = CLIPS / "concat.txt"
with open(concat_list, "w") as f:
    f.write(f"file '{(CLIPS/'intro.wav').as_posix()}'\n")
    f.write(f"file '{(CLIPS/'sil_long.wav').as_posix()}'\n")
    for i, item in enumerate(WORDS):
        # slow word ×2, sentence, long pause
        for clip in [f"w{i:02d}_slow.wav", "sil_short.wav",
                     f"w{i:02d}_slow.wav", "sil_short.wav",
                     f"w{i:02d}_sent.wav", "sil_long.wav"]:
            f.write(f"file '{(CLIPS/clip).as_posix()}'\n")

OUT_WAV = Path("/Users/ziyun/Desktop/pronunciation_drill.wav")
OUT_M4A = Path("/Users/ziyun/Desktop/pronunciation_drill.m4a")
subprocess.run([
    "ffmpeg","-y","-loglevel","error",
    "-f","concat","-safe","0","-i", str(concat_list),
    "-c","copy", str(OUT_WAV)
], check=True)
# Smaller m4a too
subprocess.run([
    "ffmpeg","-y","-loglevel","error",
    "-i", str(OUT_WAV), "-c:a","aac","-b:a","96k", str(OUT_M4A)
], check=True)

print(f"\n✓ {OUT_WAV.name}  ({OUT_WAV.stat().st_size//1024} KB)")
print(f"✓ {OUT_M4A.name}  ({OUT_M4A.stat().st_size//1024} KB)")
