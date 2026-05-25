---
name: script-voice
description: Write spoken-cadence video scripts in English for short-form (60-180s TikTok / YouTube Shorts / Reels / 小红书) and mid-length (3-10min B站 / YouTube). Voice is an AI educator + learner sharing what they figured out, not an authority being consulted. Enforces no em-dashes, no phrase fragments, no creator-trope openings or generic CTAs. Every script must contain one 干货 insight that reframes the topic at a deeper layer. Self-contained — no need to compose with another script skill.
---

# Script Voice

A complete, self-contained skill for writing my own video scripts. Replaces the generic `video-script-writing` skill — opinionated for one channel's voice instead of being maximally flexible.

## When to Use

Load this skill when:

- Drafting a new short-form video script (60-180s)
- Drafting a mid-length explainer (3-10min)
- Revising any existing draft that feels creator-tropey, robotic, or AI-generated
- Adapting a long-form piece down into Shorts cuts
- Tightening pacing, fixing flat hooks, replacing generic CTAs

Do NOT use for:

- Marketing copy, sales scripts, ad reads (different voice rules)
- Long-form YouTube essays > 15 min (use a different skill or none — those need their own cadence)
- Non-tech topics (the voice profile is calibrated to AI/tech education)
- Written articles or blog posts (use prose skills instead — script cadence reads weird on the page)

## Voice Profile (anchor for every revision)

The speaker is an **AI educator who is also actively learning**. Not a podcast guru. Not a news anchor. Not someone being consulted for expert opinion.

- Curious tone, never authoritative
- "What I find interesting", "the lens I keep coming back to", "the detail I don't see explained enough"
- Never "every time someone asks me", "as an expert", "the thing nobody is talking about"
- No false modesty either ("I'm just learning this", "I might be wrong but"). Confident but observational.
- "We" only when including the viewer (`we finally had an algorithm`), not royal-we

---

## Constraints (read top-down before writing)

Six hard rules. Each one comes from a real revision where the model got it wrong and had to be corrected.

### 1. Never use em-dashes (—)

Em-dashes feel written, not spoken. Replace every `—` with a period or a comma.

```
BAD:   It came out in 2017 — and changed everything.
GOOD:  It came out in 2017. It changed everything.
```

### 2. Never write phrase fragments

Every line that ends in a period must be a complete sentence with subject **and** verb. Fragments belong in slide text, not in spoken script.

```
BAD:   Eight pages, 2017.
BAD:   One word at a time.
BAD:   No grammar, no meaning, no context.

GOOD:  The paper is eight pages long. It came out in 2017.
GOOD:  It read one word at a time.
GOOD:  There was no grammar. There was no meaning. There was no context.
```

### 3. Never use creator-trope openings

These signal "internet creator" energy and feel fake within 2 seconds.

```
BAD:   "OK so quick thing that blew my mind"
BAD:   "You won't believe..."
BAD:   "Today we're talking about..."
BAD:   "Let me tell you..."
BAD:   "Buckle up..."
BAD:   "Here's something wild..."
BAD:   "Hey everyone, welcome back to the channel"
```

Replace with: a "you" statement plus a specific claim, **or** drop straight into a surprising fact.

### 4. Never use generic CTAs at the end

The closing should hand the viewer a thought tool, not a request for engagement.

```
BAD:   "Follow for more breakdowns."
BAD:   "Subscribe if you want more."
BAD:   "Hope that helps."
BAD:   "Wild, right?"
BAD:   "Smash that like button."
BAD:   "Comment your thoughts below."
```

Replace with: a reusable mental framework, OR an invitation to comment on something specific (`What's a rule everyone knows but nobody wrote down?`).

### 5. Never position the speaker as a consulted authority

```
BAD:   "Every time someone asks me about X, I send them..."
BAD:   "As an expert in this space..."
BAD:   "The thing nobody is talking about..."
BAD:   "Most people don't realize that..."

GOOD:  "What I find interesting about this is..."
GOOD:  "The lens I keep coming back to..."
GOOD:  "Here's the detail I don't see explained enough..."
```

### 6. Never read like slide annotations

Each line should be how a real person speaks, not how text appears on a slide.

```
BAD:   "The Transformer. An 8-page paper. From 2017."
GOOD:  "The paper is called the Transformer. It came out in 2017. It's only eight pages long."

BAD:   "Top is X. Below that, Y. At the bottom, Z."
GOOD:  "At the very top is X. Below that comes Y. And at the very bottom is Z."
```

### Also avoid (universal cadence anti-patterns)

- **Meta-commentary about the script itself**: "this is the most important slide", "if you remember one thing", "we've got a lot to cover"
- **Forecasting / recapping**: "we'll come back to this in two slides", "more on that later", "to recap what we just covered"
- **Navigation hints / slide counts / timing references**
- **AI-tell vocabulary**: `delve`, `dive into`, `navigate`, `leverage`, `tapestry`, `journey`, `comprehensive`, `robust`, `seamless`, `ecosystem` (unless literal), `in today's fast-paced world`, `it's important to note that`
- **Bare list openers**: "Twelve skills," "Three reasons," "Four patterns" as standalone — either fold the count into a sentence or skip
- **Auto-balanced categories** (forcing every category to N items). If natural set is uneven, leave it uneven.
- **Emojis in script body** (OK in pre-recording outline notes, not in delivered script)

---

## Format Decision

Pick the format first. Different formats have different hook, structure, and closing rules.

| Format | Length | Where it lives | Word count target (165 wpm) |
|---|---|---|---|
| **Short** | 60-90s | TikTok / YT Shorts / 小红书 / IG Reels | ~165-250 |
| **Long Short** | 90-180s | Same platforms (Shorts now allows 3 min) | ~250-510 |
| **Mid-length** | 3-10 min | B站, YouTube secondary channel | ~500-1650 |

All three formats use the same voice profile and constraints. They differ in **hook intensity** and **section count**.

---

## Hook (the first 5-10 seconds)

The hook is the single highest-leverage thing in any short. First 2 seconds decide whether the viewer keeps watching. 80% of the work is here.

### Hook formula (default for short and long-short)

Three short sentences, ~20 words total.

```
[You statement.]
[Surprising claim about that thing.]
[Anchoring detail: specific number, year, or size.]
```

**Examples**:

> You use ChatGPT every day. It's all built on one paper from 2017. The paper is only eight pages long.

> You think a bigger context window makes AI smarter. It doesn't. Sometimes it makes it dumber.

> Refactor is the most boring part of my week. It's also the most automatable. Let me show you why.

### Hook formula (mid-length)

Can extend to 4-6 sentences. Same pattern: you-statement → claim → anchoring detail → transition.

Mid-length hooks can also start with **a question the viewer recognizes from their own life**:

> Why does ChatGPT suddenly explode in capability around 2020? It's not what most explanations tell you.

### Hook rules (apply to all formats)

- The hook IS the headline. If it can't double as the thumbnail text, rewrite it.
- No self-intro, no "today we'll cover", no length disclosure.
- Numbers in the hook are concrete (`eight pages`, not `a short paper`).
- No setup phrases (`So`, `Alright`, `OK`) before the first sentence — those are throat-clearing.

---

## Body

### Universal rules

- **One idea per sentence**
- **Each section delivers one beat** (a claim, an explanation, an example, a takeaway) — not four bullets glued together
- **Continuous prose with connectors** (`so`, `and`, `because`, `the thing is`, `what that means`, `honestly`) — these are speech scaffolding, not filler
- **Spoken pivots between sections** (`Now let's talk about`, `Here's where it gets interesting`, `Quick aside`) — sparingly, once per major shift

### Section structure by format

**Short (60-90s)**: ONE idea total. Three beats: setup → reveal → so-what. Each beat 1-2 sentences.

**Long Short (90-180s)**: One main idea with 2-3 supporting sub-points. ~6-12 seconds per slide if doing slide-paired video. Insert one pivot at the major turn.

**Mid-length (3-10min)**: 3-5 named sections, each 45-90 seconds. Open each with a one-sentence transition. Close each on a takeaway, not a summary.

### Sentence length

- Target average: **12-18 words**
- Mix down to 6 words for emphasis
- Mix up to 25 occasionally for a flowing complex thought
- If any sentence exceeds 25 words, split it

### Word-level choices

- **Concrete > abstract**. `The harness re-sends your full history every request` beats `the system maintains conversational state`.
- **Active > passive**. `The model emits a tool call` beats `a tool call is emitted`.
- **Specific examples over generic gestures**. `Claude Code, Cursor` beats `modern AI tools`.
- **Numbers under 10 spelled out** in spoken script (`eight pages`, `thirty years`). Digits for 10 and up (`175 billion`, `100 million`).
- **Years always digits** (`2017`, `1990s`).
- **Acronyms expanded once**, then used freely (`RNN stands for Recurrent Neural Network. RNNs were the first time...`).
- **Contractions everywhere a human would use them** (`I'm`, `you're`, `that's`, `isn't`, `won't`, `we've`). No `I am` or `that is` unless emphasizing.

### What to cut

These are dead weight in every script:

- Forward references (`we'll cover X in a few minutes`)
- Backward recaps (`so just to recap what we covered`)
- Meta-flagging (`this is really important`, `if you remember one thing`)
- Self-narration about the medium (`this video`, `this slide`, `twenty-six slides`)
- Filler reassurance (`don't worry if you don't get this`, `this might sound complex`)
- Doubled definitions (`the harness, which is the software that wraps the model — basically the wrapper around the model`)

---

## 干货 Insight (mandatory)

Every script must contain **one paragraph that reframes the topic at a deeper layer**. This is what separates the script from a Wikipedia summary or a casual blog post.

### Patterns that work

| Reframe type | Example |
|---|---|
| Hardware / substrate constraint behind the algorithm | "GPUs hate sequential work. Transformer wasn't smarter, it was shaped for the chips." |
| Economic / cost pressure behind the design | "Every retry costs tokens. Idempotency isn't a nicety, it's a cost ceiling." |
| Historical context most explanations skip | "Bahdanau's attention came in 2014, three years before the Transformer." |
| Second-order effect | "Reading in parallel didn't just speed up training. It made the model finally fit the hardware." |
| Inversion of common wisdom | "The real rule isn't 'use the biggest context window.' It's the opposite." |

### Signal the insight clearly

Use one of these signposts so the viewer knows the big moment is here:

> And here's the detail I don't see explained enough.

> But there's one thing in this paper that most explanations skip.

> The part that doesn't get talked about enough is this.

> What's actually happening underneath is different.

---

## Closing (10-15 seconds)

Hand the viewer a portable mental framework. Don't ask for engagement.

### Pattern A — "What I find interesting"

> What I find interesting about this isn't X. It's Y.

End on a quotable sentence that captures the reframe.

### Pattern B — "The lens I keep coming back to"

> That's the lens I keep coming back to whenever Z shows up. I ask [question]. [Memorable closing line.]

### Pattern C — Concrete action (tactical / how-to videos only)

> If this helped, [specific concrete action — go build, go try, go read]. [Acknowledge the gap between watching and doing.] [Specific comment prompt about what they built or tried.]

### Pattern D — Comment hook (when topic invites discussion)

End by inviting a SPECIFIC comment, not a generic one:

> What's a rule in your codebase that everyone knows but nobody wrote down?

NOT: "Drop your thoughts below."

### Closing rules

- Last sentence is screenshot-worthy on its own
- Never `hope that helps`, `wild right`, `follow for more`
- Never disclose video length, channel branding, or self-promote in closing
- If channel mention is needed (e.g. tying short to long-form), make it informational not promotional: `Full 50-minute breakdown on the channel.`

---

## Workflow

### Phase 1 — Premise (10 min, no script yet)

Before writing a word, answer in 1-2 sentences each:

1. What's the ONE thing the viewer should walk away knowing?
2. What does the viewer already (wrongly) believe about this?
3. What's the concrete mental tool they should keep?
4. Why do I find this interesting? (informs voice, not the script)

If you can't answer #1 in 15 words, the topic isn't ready.

### Phase 2 — Structure (10 min)

- Pick format from the matrix above
- Sketch section list as headings, in order
- Write a one-line takeaway for each section
- Verify takeaways tell a coherent story in order

### Phase 3 — Draft (30-60 min)

- Write the hook **last**, not first — you can only hook well when you know what you're hooking into
- Each section in continuous prose
- Identify which paragraph is the 干货 insight, signal it clearly
- Overshoot length — easier to cut than expand

### Phase 4 — Read-aloud pass (15 min) — non-negotiable

Read the entire script aloud, performance voice. Listen for:

- Sentences that trip the tongue → break them up
- Bullet-style prose disguised as paragraphs → connect with prose
- Padding (`so what I want to say is...`) → cut
- Doubled definitions → keep one
- Forward references → delete
- AI-tell vocabulary → replace

### Phase 5 — Tighten (15 min)

- Cut every sentence that doesn't deliver new info or signal voice
- For each paragraph, ask: "Could I open with the second sentence and lose the first?" Often yes.
- Word-level pass against constraint list

### Phase 6 — Pre-lock check

Run the self-check below. Any unchecked item → revise before declaring done.

---

## Output Templates

### Short / Long Short

```
[HOOK — 3 short sentences, ~20 words, ends on anchoring detail]

[TRANSITION — one sentence pivoting to body, e.g. "Let me walk you through it."]

[BODY — one main idea, optionally 2-3 supporting beats, each 15-25s]

[干货 INSIGHT — one paragraph, signaled with "Here's the detail I don't see explained enough" or similar]

[CLOSING — Pattern A or B, ends on a quotable line]
```

### Mid-length (3-10 min)

```
# [Video Title]

## HOOK (0-15s)
[Question or you-statement + claim + anchoring detail]

## SECTION 1 — [name] (45-90s)
[Continuous prose, opens with transition, closes on takeaway]

## SECTION 2 — [name] (45-90s)
[...]

[3-5 sections total]

## 干货 INSIGHT (within whichever section is the heart of the video)
[One paragraph, signaled]

## CLOSE (15-30s)
[Pattern A or B or C, ends on quotable line]
```

---

## Pre-lock Self-Check

Every unchecked item → fix before declaring done.

- [ ] Zero em-dashes (`—`)
- [ ] Every sentence has subject + verb (no phrase fragments)
- [ ] Opening is ≤3 sentences (short) or ≤6 (mid-length), includes "you" + specific number or year
- [ ] No banned opener tropes (`OK quick thing`, `today we'll`, `wild right`, etc.)
- [ ] No banned closing tropes (`follow for more`, `hope that helps`, etc.)
- [ ] Speaker voice is learner + educator, not consulted authority
- [ ] One paragraph is identifiably the 干货 insight, signaled clearly
- [ ] Closing uses Pattern A / B / C / D
- [ ] Closing last line is screenshot-worthy on its own
- [ ] Read aloud once — no sentence trips the tongue
- [ ] No AI-tell vocabulary (`delve`, `leverage`, `comprehensive`, `seamless`, etc.)
- [ ] Word count matches format target (divide by 165 to get seconds)

---

## Known Anti-Patterns (from real revisions)

These are pulled from actual back-and-forth revisions. The model has tried each and been rejected.

| Anti-pattern | Why it fails | Fix |
|---|---|---|
| `OK quick thing that blew my mind...` | Creator trope. Every AI Shorts opens this way. | Drop entirely. Open with the fact or a "you" statement. |
| `Wild, right? Follow for more.` | Generic. Adds nothing. | Use closing Pattern A, B, or D. |
| `Every time someone asks me about X...` | Self-coronation. Speaker is a learner, not a guru. | "What I find interesting about X is..." |
| `Eight pages. 2017. Game-changer.` | Slide bullets, not speech. | "It's eight pages long. It came out in 2017." |
| `The thing — and this is wild — that...` | Em-dash interrupting cadence. | Two complete sentences. |
| `Most people don't realize that...` | Patronizing. | "Here's the detail I don't see explained enough." |
| `Today we're going to talk about...` | Wastes opening 5 seconds. | Just start. |
| `ChatGPT, Claude, Gemini.` (as standalone) | List fragment. | "ChatGPT, Claude, and Gemini are all variants of what's in this paper." |
| `Top is X. Below that, Y. At the bottom, Z.` | Reading a slide diagram aloud. | "At the very top is X. Below that comes Y. And at the very bottom is Z." |
| `Hope that helps. Don't forget to subscribe.` | Two CTAs, both generic. | One closing line that's quotable, or one specific comment prompt. |

---

## Worked Example — Hook Revision

**Bad** (throat-clearing creator opener):

> "Hey everyone, welcome back to the channel. Today I want to talk about the Transformer paper and some of the things I've learned about how it changed AI..."

**Better** (still slightly authoritative):

> "Every time someone asks me why AI exploded around 2020, I send them the same answer. It was one paper in 2017."

**Best** (educator-learner, hook formula):

> "You use ChatGPT every day. It's all built on one paper from 2017. The paper is only eight pages long."

---

## Worked Example — Paragraph Revision

**Bad** (bullet-style prose):

> "Context has a layered shape. Top is the provider's system prompt — locked, invisible. Below that, your instructions and tool definitions. Below that, your working material — files, examples, retrieval results. At the bottom, conversation turns."

**Good** (continuous speech):

> "Context has a layered shape that's pretty consistent across most LLM workflows. At the very top there's a layer you don't control. That's the provider's system prompt, baked into Claude or ChatGPT, and it's invisible to you. Then comes the stuff you do control. Your own system prompt, and the tool definitions you've registered. Underneath that is your working material. Files you've loaded, examples, retrieval results. And at the bottom is the actual conversation, with the user's latest message right at the end."

---

## Worked Example — Closing Revision

**Bad** (generic CTA):

> "Thanks for watching. Don't forget to like, subscribe, and hit the notification bell. Comment your thoughts below."

**Good — Pattern C (concrete action)**:

> "If this helped, go build one. Smallest MCP server you can imagine. Wire it to Claude Code, write a single skill, see what happens. The gap between watching and doing is bigger than it looks. Comment what you ended up building."

**Good — Pattern A (interesting reframe)**:

> "What I find interesting about this isn't that attention is magic. It's that RNN was a great idea trapped in hardware that couldn't run it. Transformer wasn't smarter, it was an idea shaped for the chips that already existed."

**Good — Pattern B (lens)**:

> "That's the lens I keep coming back to whenever a new architecture shows up. I ask what hardware it was shaped for. The math tends to follow the silicon."
