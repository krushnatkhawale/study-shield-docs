# Business value

What makes a rural family *keep* StudyShield and tell the next house. Ordered
by impact on activation and trust, not by revenue cleverness.

---

### SS-BIZ-01 — Time-to-first-quiz is the north star

| | |
|---|---|
| **Priority** | P1 |
| **Role** | Product / engineering |
| **Apps** | `study-shield` mobile, TV, `study-shield-backend` |
| **Component** | Product metric |

**Story:** As the team, we want one number — **minutes from install to first
TV result** — so we stop shipping side screens that do not move that number.

**Why:** The philosophy is parent-initiated learning instead of ads. If the
first quiz never happens, there is no product and no conversion.

**Acceptance:**

- Funnel defined: app open → child saved → TV paired → session started →
  result on phone. Each step timed (see SS-QLT-05).
- Sprint review always shows this funnel on the cheap-device pair, not only
  on the developer phone.
- A story that does not improve this funnel, kid delight, or trust needs an
  explicit "why now".

**Not this:** A vanity dashboard of DAU before activation works.

---

### SS-BIZ-02 — WhatsApp share of a win

| | |
|---|---|
| **Priority** | P1 |
| **Role** | Parent |
| **Apps** | `study-shield` mobile |
| **Component** | Results |

**Story:** As a parent, I want to send "Rohan got 8 out of 10" to the family
WhatsApp group as a picture, the way I share a school mark, so relatives see
the product without installing anything yet.

**Why:** Rural distribution is social, not store search. WhatsApp is the
channel. A clean card beats a Play Store link alone.

**Acceptance:**

- After a good or OK result, "Send to WhatsApp" is a clear button.
- Shares an image card: mascot, child's first name, subject, X out of Y,
  "StudyShield" mark. No phone number, no email, no other child's data.
- Parent can refuse. Never auto-share.
- Works with WhatsApp if installed; otherwise system share sheet.
- Shameful copy is banned ("only 2/10, try harder") — share is for pride or
  a neutral "practised Math today".

**Not this:** In-app social feed. SMS blasting. Sharing wrong-answer dumps.

---

### SS-BIZ-03 — School-syllabus trust without a brochure

| | |
|---|---|
| **Priority** | P1 |
| **Role** | Parent |
| **Apps** | `study-shield` mobile, `study-shield-backend` |
| **Component** | Select content / pack cards |

**Story:** As a parent, I want to see that this is *school work* (Class 3
Math, CBSE-like), in one line, so I trust the quiz more than a random puzzle
app.

**Why:** The bank already follows CBSE/ICSE core on the `ALL` board. That
trust is invisible in the UI.

**Acceptance:**

- Pack cards: "Class 3 · Math" plus "School topics" — not "Content pack" or
  "Freemium bundle".
- Kid Detail: "Questions match class 3 school topics".
- No false claim of being the official board paper.

**Not this:** Listing every syllabus bullet. A PDF prospectus.

---

### SS-BIZ-04 — Low-end Android is the default device

| | |
|---|---|
| **Priority** | P1 |
| **Role** | Parent, Kid |
| **Apps** | `study-shield` mobile, `study-shield` TV |
| **Component** | Performance / APK |

**Story:** As a family with a 2–3 GB phone and a cheap Android TV stick, I
want the app to start and run a quiz without heat, ads of our own, or a
300 MB download.

**Why:** The market that needs this product is not a flagship Pixel plus a
Chromecast. TV must stay a thin APK (no HTTP stack, no image CDN dependency
required for the first quiz).

**Acceptance:**

- Target: Android 8+ phone, 2 GB RAM; Android TV / stick 1.5–2 GB.
- First-quiz path stays usable on 3G/weak Wi-Fi because quiz payload is
  already on the phone when the session starts (mobile hub).
- TV APK size budget is tracked on the TV PR checklist (SS-QLT-04).
- No full-screen ads. This product *replaces* ads.

**Not this:** Dropping old API levels without measuring the rural fleet.
Shipping four densities of huge art on TV.

---

### SS-BIZ-05 — Freemium unlock after the family has won once

| | |
|---|---|
| **Priority** | P2 |
| **Role** | Parent |
| **Apps** | `study-shield` mobile, `study-shield-backend` |
| **Component** | Catalog / paywall |

**Story:** As a parent who has already seen my child finish a quiz, I want a
simple offer for more quizzes in my language, without a wall before the
first success.

**Why:** ADR already right-sized freemium to 2 quizzes per class. Conversion
should happen at delight, not at the door.

**Acceptance:**

- First two class quizzes always play (existing `QUIZZES_PER_CLASS = 2`).
- After that: one screen, one sentence: "More class 4 quizzes" + price or
  "ask us". No English legal essay.
- Paywall never appears on the TV. The kid is not the customer.
- Guest results still count so the parent is not forced to register in
  order to be allowed to pay later.

**Not this:** Per-question microtransactions. Ads on wrong answers. Dark
patterns that look like Start quiz.

---

### SS-BIZ-06 — APK share path for places Play is painful

| | |
|---|---|
| **Priority** | P2 |
| **Role** | Parent, operator |
| **Apps** | `study-shield` mobile, `study-shield` TV |
| **Component** | Distribution |

**Story:** As a parent whose Play Store is slow, full, or missing, I want a
trusted way to get the phone app and the TV app (WhatsApp file, shop
sideload, USB), with a version number I can read.

**Why:** Rural install is often "cousin sent the APK". Document and support
that path so we do not pretend only Play exists.

**Acceptance:**

- Version and "this is the phone app" / "this is the TV app" are visible on
  the first screen (icons differ strongly).
- A one-page install picture-guide lives in this docs site (Hindi/English):
  phone APK, TV APK from USB/Play, same Wi-Fi.
- Signing/versioning is stable enough that WhatsApp-shared APKs update
  without "Uninstall first?" where we can avoid it.

**Not this:** A custom app store. Encouraging unknown-source installs
without a short warning.
