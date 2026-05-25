# content-skills

Personal skills + SOPs for producing short-form educational tech videos (TikTok / YouTube Shorts / Reels / 小红书) and accompanying long-form YouTube content.

Companion to `react-fullstack-skills` (engineering) — this repo is **content production**.

## Repo structure

```
content-skills/
├── README.md                                    ← you are here
├── skills/                                      ← individual skill modules (loaded on demand by harness)
│   ├── script-voice/SKILL.md                    ← personal voice overlay; composes with the universal video-script-writing skill
│   ├── pronunciation-drill/SKILL.md             ← generate Kokoro shadowing audio for accent practice
│   ├── vertical-slide-design/SKILL.md           ← 1080×1080 HTML slides for short-form
│   ├── cover-design/SKILL.md                    ← 1080×1920 video cover thumbnails
│   └── descript-export-flow/SKILL.md            ← polish Descript export (cover + loudnorm + speed)
├── sops/                                        ← multi-skill workflows
│   └── publish-short-video.md                   ← end-to-end SOP, ~4.5h first time, ~2h fluent
├── scripts/                                     ← shared cross-skill utilities
│   └── make_drill.py                            ← reference impl for pronunciation-drill
└── _archive/                                    ← old drafts kept for reference, do not load
```

## Skills index

| Skill | When to load | Composes with |
|---|---|---|
| **script-voice** | Drafting / revising any short-video script for the personal channel | self-contained; `pronunciation-drill` (downstream) |
| **pronunciation-drill** | After script is locked, before recording, when narrator wants to practice | `script-voice` (upstream) |
| **vertical-slide-design** | After script is locked, to create 10-15 slides for vertical 9:16 video | `cover-design` (shares render pipeline) |
| **cover-design** | After video is exported, to make a 1080×1920 cover thumbnail | `vertical-slide-design` (design tokens), `descript-export-flow` (consumer) |
| **descript-export-flow** | After Descript export, to apply cover + loudnorm + 1.2x speed | `cover-design` (provides input) |

## SOPs index

| SOP | When to use |
|---|---|
| **publish-short-video** | End-to-end workflow from topic idea to published short on 2+ platforms |

## Install per harness

### Claude Code (user-level, all projects)

```bash
mkdir -p ~/.claude/skills
ln -s ~/Desktop/content-skills/skills/script-voice ~/.claude/skills/script-voice
ln -s ~/Desktop/content-skills/skills/pronunciation-drill ~/.claude/skills/pronunciation-drill
ln -s ~/Desktop/content-skills/skills/vertical-slide-design ~/.claude/skills/vertical-slide-design
ln -s ~/Desktop/content-skills/skills/cover-design ~/.claude/skills/cover-design
ln -s ~/Desktop/content-skills/skills/descript-export-flow ~/.claude/skills/descript-export-flow
```

Symlinks let you edit the source files and have changes live in Claude Code immediately.

### Claude Code (project-level only)

```bash
cd path/to/some/project
mkdir -p .claude/skills
ln -s ~/Desktop/content-skills/skills/script-voice .claude/skills/script-voice
# ... etc, only the ones relevant to this project
```

### Cursor

Cursor's rules live under `.cursor/rules/` as `.mdc` files (different format). For now, reference the skill content manually or convert. Future: write `agentpkg` projector for cross-harness install.

### Plain Claude / Anthropic API

Reference the skill paths in your system prompt. Example:

```
When the user asks for a video script, load the following:
- /Users/ziyun/Desktop/content-skills/skills/script-voice/SKILL.md

When the user asks for slide design, load:
- /Users/ziyun/Desktop/content-skills/skills/vertical-slide-design/SKILL.md
```

## How to use this repo with an agent

### Single skill

> "Use `script-voice` to write a 90-second short on `[topic]`."

### Multi-skill compose

> "Use `video-script-writing` + `script-voice` for the script, then `pronunciation-drill` for the drill audio."

### Full SOP

> "Follow the `publish-short-video` SOP. Topic: `[X]`. Stop at Phase 4 — I'll record manually in Phase 6."

## Conventions

- Every skill follows the structure from the long-form `video-script-writing` reference (slide 21 of the AI-Engineering reference deck): frontmatter, When to Use, Composes With, Constraints (negatives first), Procedure, Output Template (contract), Self-check
- Description in frontmatter is **trigger-shaped, not topic-shaped** — it tells the harness *when* to load the skill, not *what* the skill contains
- Constraints come BEFORE procedure — the model reads top-down, and prohibitions deserve the first attention
- Every skill ends with a fenced output template that's the contract for what a successful run produces
- Scripts and templates live in `scripts/` and `templates/` subdirectories of each skill, not in the SKILL.md itself

## Adding a new skill

1. Create `skills/<name>/SKILL.md` following the structure of the existing ones
2. Description ≤ 200 characters, trigger-shaped (`Use when …`, not `A skill for …`)
3. List explicit constraints before procedure
4. End with output-template contract
5. Add scripts to `skills/<name>/scripts/` if implementation is non-trivial
6. Register in the table above
7. If this skill chains with others, list both directions in `Composes With`

## Versioning

Treat each `SKILL.md` as living documentation. Edit in place. If a major behavior change would break existing call sites, add a `## Changelog` section at the bottom and document the change.

For experimental skills, prefix with `_` (e.g., `_bgm-selection/`) — they won't be auto-loaded by symlinks unless explicitly added.
