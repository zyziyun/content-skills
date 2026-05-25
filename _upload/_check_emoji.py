"""Strict emoji check. Allowlist mode: only flag decorative emoji.
Does NOT flag: — → × ↓ ↑ ← ▶ ✓ (functional Unicode punctuation/symbols).
"""
import sys, pathlib

# Explicit deny — these are decorative emoji we agreed to remove from skills.
# Add to this set as needed.
BANNED = set('❌✅⭐★🔥💡📝📌🎬🎥👋📊📈📉🚀🎯💯🙌👍👎✨🎉')

p = pathlib.Path(sys.argv[1])
text = p.read_text()
hits = {}
for i, line in enumerate(text.splitlines(), 1):
    for c in line:
        if c in BANNED:
            hits.setdefault(c, []).append((i, line.strip()[:80]))

if hits:
    for c, occurrences in hits.items():
        print(f"  banned char {c!r}: {len(occurrences)} occurrence(s)")
        for i, sample in occurrences[:3]:
            print(f"    line {i}: {sample}")
    sys.exit(1)
