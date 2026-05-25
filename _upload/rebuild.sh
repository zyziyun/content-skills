#!/usr/bin/env bash
# Rebuild all upload-ready skill bundles for claude.ai.
# Run this after editing any SKILL.md or assets under skills/<name>/.
#
# Usage:
#   ./rebuild.sh                   # rebuild everything
#   ./rebuild.sh script-voice      # rebuild one skill
#
# Validates:
#   - YAML frontmatter exists with `name` and `description`
#   - Description length is sane (<= 1024 chars)
#   - Zip files have SKILL.md at the root, not nested
#   - No forbidden emoji characters in skill text

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_DIR="$ROOT/skills"
OUT="$ROOT/_upload"

# Single-file uploads (just SKILL.md, no extra assets needed for upload)
SINGLE=(script-voice pronunciation-drill)

# Multi-file uploads (must include templates/ or scripts/)
MULTI=(vertical-slide-design cover-design descript-export-flow)

# Forbidden emoji chars (decorative only; play-glyph U+25B6 is OK as content)
FORBIDDEN_EMOJI='[❌✅⭐★🔥💡📝📌🎬🎥👋😀-🙏]'

ONLY="${1:-}"
fail=0
ok=0

validate_md() {
    local md="$1"
    local name
    name=$(basename "$md" .md)

    # 1. YAML frontmatter present
    if ! head -1 "$md" | grep -q '^---$'; then
        echo "  FAIL $name: missing YAML frontmatter opening ---"
        return 1
    fi

    # 2. name + description keys present
    local fm
    fm=$(awk '/^---$/{f++; next} f==1{print} f==2{exit}' "$md")
    if ! echo "$fm" | grep -q '^name:'; then
        echo "  FAIL $name: missing `name:` in frontmatter"
        return 1
    fi
    if ! echo "$fm" | grep -q '^description:'; then
        echo "  FAIL $name: missing `description:` in frontmatter"
        return 1
    fi

    # 3. Description length sanity
    local desc_chars
    desc_chars=$(echo "$fm" | awk -F': ' '/^description:/{print length($2)}')
    if [ "${desc_chars:-0}" -gt 1024 ]; then
        echo "  WARN $name: description is ${desc_chars} chars (recommended <= 1024)"
    fi

    # 4. Forbidden emoji scan (via Python — BSD grep can't handle Unicode reliably)
    if ! python3 "$ROOT/_upload/_check_emoji.py" "$md" 2>&1 | sed 's/^/        /'; then
        echo "  FAIL $name: forbidden emoji present (see above)"
        return 1
    fi

    return 0
}

validate_zip() {
    local zip="$1"
    local name
    name=$(basename "$zip" .zip)

    # SKILL.md must be at root, not nested
    if ! unzip -l "$zip" | awk '{print $4}' | grep -qx 'SKILL.md'; then
        echo "  FAIL $name.zip: SKILL.md not at zip root"
        echo "        zip contents:"
        unzip -l "$zip" | sed 's/^/          /'
        return 1
    fi
    return 0
}

build_single() {
    local name="$1"
    local src="$SKILLS_DIR/$name/SKILL.md"
    local dst="$OUT/$name.md"

    if [ ! -f "$src" ]; then
        echo "  SKIP $name (no SKILL.md at $src)"
        return 1
    fi

    cp "$src" "$dst"
    if validate_md "$dst"; then
        local lines size
        lines=$(wc -l < "$dst" | tr -d ' ')
        size=$(du -h "$dst" | awk '{print $1}')
        echo "  OK   $name.md  ($size, $lines lines)"
        return 0
    else
        rm -f "$dst"
        return 1
    fi
}

build_multi() {
    local name="$1"
    local dir="$SKILLS_DIR/$name"
    local dst="$OUT/$name.zip"

    if [ ! -f "$dir/SKILL.md" ]; then
        echo "  SKIP $name (no SKILL.md in $dir)"
        return 1
    fi

    # Validate the source SKILL.md first
    if ! validate_md "$dir/SKILL.md"; then
        return 1
    fi

    rm -f "$dst"
    (
        cd "$dir"
        # Include SKILL.md + every dir that exists (templates, scripts, etc.)
        local items=(SKILL.md)
        for sub in templates scripts assets references; do
            [ -d "$sub" ] && items+=("$sub")
        done
        zip -r -X "$dst" "${items[@]}" > /dev/null
    )

    if validate_zip "$dst"; then
        local size files
        size=$(du -h "$dst" | awk '{print $1}')
        files=$(unzip -l "$dst" | awk 'END{print $2}')
        echo "  OK   $name.zip ($size, $files files)"
        return 0
    else
        rm -f "$dst"
        return 1
    fi
}

mkdir -p "$OUT"

echo "Rebuilding upload bundles in $OUT"
echo ""

for n in "${SINGLE[@]}"; do
    if [ -z "$ONLY" ] || [ "$ONLY" = "$n" ]; then
        if build_single "$n"; then ok=$((ok+1)); else fail=$((fail+1)); fi
    fi
done

for n in "${MULTI[@]}"; do
    if [ -z "$ONLY" ] || [ "$ONLY" = "$n" ]; then
        if build_multi "$n"; then ok=$((ok+1)); else fail=$((fail+1)); fi
    fi
done

echo ""
echo "Done. $ok ok, $fail failed."

if [ "$fail" -gt 0 ]; then
    exit 1
fi

echo ""
echo "Upload these to claude.ai (replace existing if already uploaded):"
ls -1 "$OUT"/*.md "$OUT"/*.zip 2>/dev/null | sed 's|^|  |'
