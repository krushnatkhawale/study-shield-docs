# Experience

How a parent starts a quiz and how a kid plays it. Ordered by priority inside this
group. Global rank lives on the [backlog home](index.md).

---

### SS-EXP-01 — Three steps to first quiz

| | |
|---|---|
| **Priority** | P0 |
| **Role** | Parent (rural, low digital literacy) |
| **Apps** | `study-shield` mobile |
| **Component** | Onboarding / Home |
| **Depends on** | SS-EXP-02 (pairing), SS-EXP-06 (age picker) |

**Story:** As a parent opening StudyShield for the first time, I want only three
clear steps — *add my child*, *connect the TV*, *start the quiz* — so I can succeed
without hunting through a drawer of screens.

**Why:** Time-to-first-quiz is the product. Today's Library / Interrupter / IP /
Select Content path is a technician flow. A parent who uses WhatsApp and YouTube
will abandon a seven-screen setup.

**Acceptance:**

- After install (guest or signed-in), the first screen is a numbered path: 1 Child,
  2 TV, 3 Start.
- Each step is one screen, one primary button, one skip only where safe (TV scan
  can retry).
- A parent who already has a child and a remembered TV lands on **Start quiz** as
  the only large button on Home.
- Drawer items that are not needed for first success (ProfData, Quiz Setup,
  Parents, debug) are hidden until the first quiz has completed, or sit behind
  "More".
- Copy is short: "Add child", "Find TV", "Start quiz". No "Activate interrupter".
- Demo'd on a 5–6" phone, one hand, in Hindi or English (see SS-EXP-03).

**Not this:** A longer carousel. A wizard that asks board, PIN, second parent, and
content pack before the first play.

---

### SS-EXP-02 — Pair the TV without typing an IP

| | |
|---|---|
| **Priority** | P0 |
| **Role** | Parent |
| **Apps** | `study-shield` mobile, `study-shield` TV |
| **Component** | LAN pairing (`TvServerService`, Connected TVs) |

**Story:** As a parent, I want the phone to find the TV the way a TV remote app
does — big name, one tap — so I never type `192.168.x.x`.

**Why:** IP addresses are the number-one rural drop-off. Shared routers, AP
isolation, and "what is an IP" kill the session before the kid sees a question.

**Acceptance:**

- TV idle shows a **4-digit room code** (or QR) in huge type, plus "Ready to play".
  The IP may remain in small print for support, not as the hero.
- Mobile "Find TV" lists discovered TVs by device name; tapping one pairs.
- If discovery fails: "Type the 4-digit number on the TV" — numeric keypad only.
- Success state: green "TV ready" with the TV's name, then the Start quiz button
  unlocks.
- Pairing is remembered next launch.
- Failure copy names the usual fix: "Phone and TV must use the same Wi-Fi"
  (see SS-REL-03). Never "connection refused" or "callback port".

**Not this:** mDNS-only with no fallback. A settings page of ports. Making the TV
call the internet.

---

### SS-EXP-03 — App speaks the parent's language

| | |
|---|---|
| **Priority** | P0 |
| **Role** | Parent |
| **Apps** | `study-shield` mobile (TV already has greeting locale) |
| **Component** | Strings / Settings |

**Story:** As a parent who reads Hindi or Marathi more comfortably than English, I
want the *whole parent app* in my language so I can set up a quiz without guessing
English buttons.

**Why:** Greeting TTS on the TV is not enough. The hard part is setup. Rural
parents will not map "Library", "Select Content", and "Session Confirmed" to
actions.

**Acceptance:**

- First-run language choice: हिंदी / मराठी / English. One tap, immediately applied.
- All parent-facing screens used in the first-quiz path are translated (Home,
  add child, find TV, start, results).
- Language can be changed later in Settings without losing the child or TV.
- Numerals and scores stay as digits (`8 / 10`) — digits are shared.
- TV kid-facing strings follow the existing per-kid greeting language; do not
  build a language settings UI on the TV.

**Not this:** Machine-translated paragraphs. Mixing English jargon inside Hindi
sentences ("क्विज बंडल सीड करें").

---

### SS-EXP-04 — Performance in plain words, not charts-first

| | |
|---|---|
| **Priority** | P0 |
| **Role** | Parent |
| **Apps** | `study-shield` mobile |
| **Component** | Kid Detail / Results |

**Story:** As a parent, I want to open my child's name and immediately see
whether they did well, in words I would say to a neighbour — not a donut chart.

**Why:** Charts are for product people. A parent wants: "Rohan did well today"
or "Math needs practice". Fast-answer warnings must be gentle, not accusatory.

**Acceptance:**

- Kid card and Kid Detail lead with: name, last quiz, **X out of Y**, and one
  phrase: *Did well* / *OK* / *Needs practice* (localized), with a colour that
  is not the only signal (see SS-DSN-06).
- Charts (bar/donut) sit under "See more", collapsed by default.
- Fast answers: "Answered very quickly — maybe guessing" — never shown on TV,
  never as a red "cheat" badge the child could see on a shared phone lockscreen.
- Empty state: "No quiz yet. Start one." with the Start button, not an empty
  chart.
- Two quizzes in a row: parent can tell which was today without timestamps as
  the only label ("Afternoon quiz", "Morning quiz").

**Not this:** More graph types. Per-question analytics on the first screen.
Percentiles or "rank in class".

---

### SS-EXP-05 — Hide engineering words

| | |
|---|---|
| **Priority** | P0 |
| **Role** | Parent |
| **Apps** | `study-shield` mobile, `study-shield` TV |
| **Component** | Copy / Library / Idle TV |

**Story:** As a parent, I want buttons and messages that name *what I am doing*
(start quiz, stop quiz, TV ready), not what the socket is doing.

**Why:** Current copy still leaks the architecture: Interrupter, Activate,
callback, Exp/Trial, packs, bundles. That copy trains the team and scares the
user.

**Acceptance:**

- Glossary for UI (enforced in review): Start quiz, Stop quiz, TV ready,
  Child, Class/age, Subject, Result. Banned in parent UI: interrupter,
  callback, socket, bundle, seed, JWT, modulith, command.
- TV idle headline is "Ready to play", not "Interrupter Ready".
- "Emergency unlock" becomes "Stop quiz / unlock TV" with a confirm.
- Guest vs account: guest can complete first quiz; sign-up is offered *after*
  success ("Save this so you don't lose Rohan's results").

**Not this:** A help wiki. Tooltips on every jargon word — delete the jargon.

---

### SS-EXP-06 — Pick the child by age and photo, not board jargon

| | |
|---|---|
| **Priority** | P1 |
| **Role** | Parent |
| **Apps** | `study-shield` mobile |
| **Component** | Kid form |

**Story:** As a parent, I want to add my child with a name, a photo or mascot,
and "how old / which class" in everyday words, so I do not have to know
"Trial", "Sr KG", or board codes.

**Why:** `Exp` → `Trial` → Nursery is already a rename trail. Parents say
"UKG" or "5 years" or "class 3". The form should accept those and map to the
bank internally.

**Acceptance:**

- Fields: name (required), photo or mascot picker (existing 12 avatars are
  enough), class as a big visual list: Nursery, LKG, UKG, 1 … 10 — each with
  typical age in small print.
- No "board" field on first add. Default `ALL` (already the bank).
- Saving the child is one button. Quiz presentation (read-lock, TTS) is *not*
  on this form; it stays on Kid Detail under "How the quiz looks".
- Default kid name is not "Kid 1" after first run — empty name is invalid with
  "Write your child's name".

**Not this:** Asking for school name, UDISE, or Aadhaar. Multi-board pickers
on day one.

---

### SS-EXP-07 — Voice walkthrough for setup

| | |
|---|---|
| **Priority** | P1 |
| **Role** | Parent (mixed literacy) |
| **Apps** | `study-shield` mobile |
| **Component** | Onboarding TTS |

**Story:** As a parent who reads slowly on a small screen, I want an optional
voice that speaks each setup step in my language, like a polite shopkeeper,
so I can set up without reading a paragraph.

**Why:** Literacy here is often "I can read a shop sign, not an app". Voice
already exists on TV for kids; reuse the idea on mobile for *parents*, then
silence it.

**Acceptance:**

- Optional "Speak steps" toggle, default **on** for first run in Hindi/Marathi,
  off after first successful quiz (and always off if user disables).
- Speaks one short sentence per screen, then stops. No looping.
- Works offline with on-device TTS; if the voice is missing, the screen still
  works (same pattern as TV greeting fallback).
- Does not speak results that could embarrass the child on speaker in a shop.

**Not this:** A chatbot. Continuous narration. Requiring a network voice pack
before setup can continue.

---

### SS-EXP-08 — One-tap play again for the same child

| | |
|---|---|
| **Priority** | P1 |
| **Role** | Parent |
| **Apps** | `study-shield` mobile, `study-shield` TV |
| **Component** | Home / Results |

**Story:** As a parent whose child just finished, I want **Play again** for the
same child, same TV, next quiz — one tap — so I do not re-select content while
the child is waiting on the sofa.

**Why:** The living-room moment is short. Re-walking Library → Content →
Confirm kills the second session.

**Acceptance:**

- After a result arrives, Home and the result screen show "Play again for Rohan".
- Uses the next unused freemium quiz for that class/subject if available;
  otherwise the same subject with shuffled questions.
- TV greets again (short form if within the hour — already designed).
- If TV is gone: "TV not found — open Find TV" instead of a dead tap.

**Not this:** Auto-start quizzes without the parent. A playlist builder.

---

### SS-EXP-09 — Shared phone, second adult

| | |
|---|---|
| **Priority** | P1 |
| **Role** | Second parent / grandparent |
| **Apps** | `study-shield` mobile, `study-shield-backend` |
| **Component** | Auth / Parents |

**Story:** As a grandmother using the same phone, I want to start a quiz for
Rohan without creating an email account or seeing a "parent selection" puzzle
I do not understand.

**Why:** Rural phones are shared. Email signup and multi-parent overlays look
like the app is broken. Guest already exists; it should be the *easy* path,
with save-account as a later gift.

**Acceptance:**

- Guest can add children, pair TV, run quizzes, see results on-device.
- "Save results" uses phone OTP (or a name + PIN) rather than email-first.
- If several adults exist, the default is "this phone" — not a blocking
  Parent Selection dialog on every launch.
- Sign-out is hard to hit by accident (not next to Start quiz).

**Not this:** School-style RBAC. Forcing every adult to verify email.

---

### SS-EXP-10 — Kid never sees parent controls

| | |
|---|---|
| **Priority** | P1 |
| **Role** | Kid, Parent |
| **Apps** | `study-shield` TV |
| **Component** | TV session |

**Story:** As a parent, I want the TV to show only the game, so my child cannot
unlock, skip, or wander into IP/debug screens with the remote.

**Why:** Thin TV means *no* kid-operated information architecture. Unlock and
setup stay on the phone.

**Acceptance:**

- During quiz: remote only selects among the four (or two) answers. Back/Home
  do not open a menu; Back is ignored or shows "Ask mum/dad to stop on the
  phone".
- Results auto-close (already 4 s) — keep it; no Exit button the kid must find.
- Idle: no clickable settings. Pairing code is visible but not a menu.
- Fast-answer counts, scores-as-judgement, and parent messages never appear
  on TV beyond the short praise line.

**Not this:** A kid profile picker on the TV. A TV PIN. A TV content browser.

---

### SS-EXP-11 — Numeric PIN, not email recovery

| | |
|---|---|
| **Priority** | P2 |
| **Role** | Parent |
| **Apps** | `study-shield` mobile |
| **Component** | Settings / lock |

**Story:** As a parent, I want a 4-digit PIN I already use in my head to stop
the child from starting extra quizzes on my phone, without an email reset flow
I cannot complete.

**Why:** Settings already mentions a Parental PIN. Email recovery is a trap
when the "email" was a username.

**Acceptance:**

- PIN is numeric, 4 digits, set with an illustration ("child should not open
  Start quiz").
- Forgot PIN: local reset via a pattern of already-known child name + a
  support code, or re-login — documented in simple language.
- PIN is not required before the first quiz (activation first).

**Not this:** OTP to email as the only recovery. PIN on the TV.
