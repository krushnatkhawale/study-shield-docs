# Design

Visual and interaction design that makes the TV *kid-interesting* and the
mobile *parent-obvious*. TV work is intentionally small.

---

### SS-DSN-01 — TV quiz is four huge choices, nothing else

| | |
|---|---|
| **Priority** | P0 |
| **Role** | Kid |
| **Apps** | `study-shield` TV |
| **Component** | Quiz UI (`QuizUI` / `TrueFalseUI`) |

**Story:** As a child sitting across the room, I want each question to be one
big prompt and up to four huge answers I can hit with the remote, so I never
search the screen.

**Why:** 10-foot UI. Kids miss small focus rings. Extra chrome (progress
math, pack names, IP, timers in the corner) makes the quiz feel like a test
and a settings panel.

**Acceptance:**

- Answer tiles fill most of the screen; focus scale/glow is obvious from 3
  metres on a 32" set.
- True/False is two giant tiles, not four empty slots.
- No nav bar, no hamburger, no "skip", no question counter as the hero
  (a quiet 3/5 dots is enough).
- One question per screen. No scrolling.
- D-pad: left/right or up/down among answers; OK to confirm. No long-press
  gestures.
- Wrong/right feedback is instant (colour + sound + mascot beat) then the
  next question. Do not require reading an explanation to continue (optional
  short TTS is OK).

**Not this:** FITB keyboards for under-8s (see SS-CNT-01). Leaderboards.
Picture-in-picture video players.

---

### SS-DSN-02 — Nursery/KG questions are pictures + voice

| | |
|---|---|
| **Priority** | P0 |
| **Role** | Kid (3–6), Parent |
| **Apps** | `study-shield` TV, `study-shield` mobile, `study-shield-backend` |
| **Component** | Question payload / TV render / bank |

**Story:** As a child who cannot read yet, I want to *see* the question and
*hear* it, and tap a picture, so the quiz feels like a cartoon game.

**Why:** The bank is still text-shaped (`SeedQuestion`). Quiz-design already
allows `questionImageUrl` and image options. Without pictures, Nursery is a
reading test. TTS (already shipped) covers hearing; pictures cover meaning.

**Acceptance:**

- Nursery / LKG / UKG items can ship with a question image and image options
  (all options images, or all text — no mix, per existing quiz-schema).
- TV renders image options as the same huge tiles as text.
- Auto-dictation default **on** for Nursery/LKG/UKG unless the parent turns
  it off on Kid Detail.
- If an image fails to load, the spoken question + coloured shapes still
  work; never a broken-image icon as the only content.
- Mobile review shows the same pictures so the parent can see what the child
  saw.

**Not this:** A full illustrated storybook engine on the TV. Downloading
image packs through the TV. AI-generated mascots as architecture diagrams
(already rejected).

---

### SS-DSN-03 — Mobile first-run has no hamburger maze

| | |
|---|---|
| **Priority** | P1 |
| **Role** | Parent |
| **Apps** | `study-shield` mobile |
| **Component** | Navigation |

**Story:** As a new parent, I want a single column of big tasks, not a drawer
of nine destinations, so I cannot get lost in Connected TVs vs Library vs
Quiz Setup vs Settings.

**Why:** Drawer IA matches the engineering modules. It does not match the
job. Progressive disclosure is the design move.

**Acceptance:**

- First-run shell: Home with the three steps (SS-EXP-01). Bottom or page
  actions: Home, Child, Result — not more.
- After first quiz, "More" reveals TVs, Settings, Parents.
- ProfData never appears in production builds.
- Back always returns to Home, not to a stack the parent does not remember.
- Tap targets ≥ 48 dp; body type ≥ 16 sp; primary button full width.

**Not this:** A tablet-style nav rail. Bottom nav with six items.

---

### SS-DSN-04 — Mascot is present during the quiz, not only at the end

| | |
|---|---|
| **Priority** | P1 |
| **Role** | Kid |
| **Apps** | `study-shield` TV |
| **Component** | `LiveMascot` |

**Story:** As a child, I want my character on screen *while* I play (a corner
wave, a hop on a right answer), so the quiz feels like a friend, not an exam
that celebrates at the end.

**Why:** Greeting research already said characters raise engagement. The
mascot currently peaks on the 4-second result screen. A thin implementation
is the existing code-drawn `LiveMascot`, not new illustration pipelines.

**Acceptance:**

- During questions, the kid's chosen avatar sits in a corner, idle (blink /
  breathe only — no chaotic motion that steals focus).
- Correct: short hop. Wrong: gentle "try" expression — never shame.
- Result screen keeps the current celebration and auto-close.
- No extra network, no extra screens, no kid-facing settings to "equip"
  items.

**Not this:** A wardrobe/shop. Spine/Lottie packs that bloat the TV APK.
A second mascot picker on the TV.

---

### SS-DSN-05 — Living-room contrast and D-pad focus

| | |
|---|---|
| **Priority** | P1 |
| **Role** | Kid |
| **Apps** | `study-shield` TV |
| **Component** | TV theme |

**Story:** As a child in a bright or dim living room, I want answers that
stay readable and a focus box I can see from the sofa.

**Acceptance:**

- Contrast of question and answers meets a practical 10-foot check on a
  cheap 32" panel (white/very light text on dark green is OK if tiles are
  distinct).
- Focused tile: thick border + scale, not colour-only.
- Motion stays under ~300 ms; no flashing.
- Safe margins for overscan on older sticks.

**Not this:** A full Material You redesign. Parent-facing themes on the TV.

---

### SS-DSN-06 — Bilingual labels: icon + short word

| | |
|---|---|
| **Priority** | P2 |
| **Role** | Parent |
| **Apps** | `study-shield` mobile |
| **Component** | Design system / components |

**Story:** As a parent who recognises pictures faster than English, I want
every primary action to have a simple icon *and* a short word in my language.

**Acceptance:**

- Start, Stop, Child, TV, Result each have a unique icon used everywhere.
- Do not rely on colour alone for Did well / Needs practice.
- Icon-only feedback on quiz review (👍👎🚩) gets a long-press or caption
  in the parent language — today's icon-only pattern is easy to mis-tap.

**Not this:** Emoji soup. A custom icon font project before copy is fixed.

---

### SS-DSN-07 — Idle TV says ready to play; IP is secondary

| | |
|---|---|
| **Priority** | P2 |
| **Role** | Kid, Parent (glancing at TV) |
| **Apps** | `study-shield` TV |
| **Component** | Idle state |

**Story:** As a family walking past the TV, I want a friendly "Ready to
play" with the pairing code, not a developer splash of device name + IP +
rocket.

**Acceptance:**

- Hero: mascot + "Ready to play" + large pairing code.
- Device name and IP in a small footer for the rare support case.
- After 15 s the app may yield to the home screen (current behaviour) so we
  do not hijack the TV — keep that; it is part of being thin.

**Not this:** An idle content browser. Ads. A clock app.
