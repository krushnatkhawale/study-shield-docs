# Product backlog — checked against code

Each story is an **implementation brief** you can paste into Buzz (bigpickle / muse). Copy **one card** (heading through **Verify**). How to paste, repo map, and invariants: [llm-brief.md](llm-brief.md).

**Partial** cards say **enhance which existing behaviour**. **Not in code** cards name **repo / module / files**. Status is from local checkouts, not old screen-flow docs. Audit notes: [code-audit.md](code-audit.md).

## Product constraints (still true)

| Constraint | Meaning |
|------------|---------|
| **TV stays thin** | Kid only plays. No login, catalog, or HTTP on TV. |
| **TV is for kids** | Short, personal, game-like. Not a test paper. |
| **Mobile is for parents** | Setup and results must work without a manual — especially mixed-English, cheap Android, WhatsApp-first households. |
| **Mobile is the hub** | TV never talks to the backend. |

## Roles

Kid (TV) · Parent (mobile) · Second adult / shared phone · Content author · Operator (`study-shield-backend-admin`) · Engineering.

## Code status

| Status | Meaning |
|--------|---------|
| **Done in code** | Shipped. Protect; do not rebuild. |
| **Partial** | Code exists; the outcome in the story is not finished. |
| **Not in code** | New work. |
| **Practice** | How the team works. |

## Remaining work (do this, in order)

Work **down this list**. Done items are listed after it so they are not picked as new features.

| Rank | ID | Outcome still missing | Status | Apps |
|------|----|----------------------|--------|------|
| 1 | [SS-EXP-05](experience.md#ss-exp-05-hide-engineering-words) | UI still says Interrupter, ACTIVATE, EMERGENCY UNLOCK, TV IP, Trial/Freemium pack | Not in code | Mobile, TV |
| 2 | [SS-DSN-07](design.md#ss-dsn-07-idle-tv-says-ready-to-play-ip-is-secondary) | Idle TV: “Interrupter Ready” + IP; no room code | Not in code | TV |
| 3 | [SS-DSN-03](design.md#ss-dsn-03-mobile-first-run-has-no-hamburger-maze) | Full drawer including **ProfData** after login | Not in code | Mobile |
| 4 | [SS-REL-02](reliability.md#ss-rel-02-first-quiz-bundle-in-under-two-seconds) | `ensureCatalogForClass` still on the request path (TD-1) | Partial | Backend, Mobile |
| 5 | [SS-EXP-03](experience.md#ss-exp-03-app-speaks-the-parents-language) | App chrome English-only; Hindi/Marathi is greeting TTS only | Not in code | Mobile |
| 6 | [SS-EXP-04](experience.md#ss-exp-04-performance-in-plain-words-not-charts-first) | Kid Detail is charts-first | Partial | Mobile |
| 7 | [SS-CNT-01](content.md#ss-cnt-01-short-sessions-typed-answers-are-not-for-young-kids) | Quizzes are 10 questions; Library can still send FITB | Partial | TV, Backend, Mobile |
| 8 | [SS-DSN-02](design.md#ss-dsn-02-nurserykg-questions-are-pictures-voice) | No question images; auto-dictation defaults **off** | Not in code | Mobile, TV, Backend |
| 9 | [SS-QLT-01](quality-and-speed.md#ss-qlt-01-one-schema-for-tv-mobile-commands) | Two Kotlin copies; no contract test | Not in code | Mobile, TV |
| 10 | [SS-EXP-08](experience.md#ss-exp-08-one-tap-play-again-for-the-same-child) | No Play again | Not in code | Mobile, TV |
| 11 | [SS-REL-04](reliability.md#ss-rel-04-offline-is-a-sentence-not-a-spinner) | Queues exist; parent copy is a toast, not a plain banner | Partial | Mobile |
| 12 | [SS-CNT-02](content.md#ss-cnt-02-reported-questions-reach-a-human-the-same-day) | Feedback API + blacklist exist; no admin inbox | Partial | Admin, Backend, Mobile |
| 13 | [SS-EXP-06](experience.md#ss-exp-06-pick-the-child-by-age-and-photo-not-board-jargon) | Form has name/year/grade/syllabus/mascot; default **Kid 1 / Trial** | Partial | Mobile |
| 14 | [SS-DSN-04](design.md#ss-dsn-04-mascot-is-present-during-the-quiz-not-only-at-the-end) | `LiveMascot` on results only | Partial | TV |
| 15 | [SS-REL-03](reliability.md#ss-rel-03-same-wi-fi-in-one-picture) | `NOT_ON_WIFI` for TTS probe only; no picture | Partial | Mobile |
| 16 | [SS-BIZ-02](business-value.md#ss-biz-02-whatsapp-share-of-a-win) | No share sheet | Not in code | Mobile |
| 17 | [SS-CNT-03](content.md#ss-cnt-03-hindi-subject-uses-hindi-script) | Hindi subject is English GK (documented D3) | Not in code | Backend, TV, Mobile |
| 18 | [SS-EXP-11](experience.md#ss-exp-11-numeric-pin-not-email-recovery) | Settings PIN switch is a no-op | Not in code | Mobile |
| 19 | [SS-EXP-07](experience.md#ss-exp-07-voice-walkthrough-for-setup) | No parent-setup TTS | Not in code | Mobile |
| 20 | [SS-EXP-09](experience.md#ss-exp-09-shared-phone-second-adult) | Guest works; overlay + email; no OTP; Add Parent is TODO | Partial | Mobile, Backend |
| 21 | [SS-EXP-10](experience.md#ss-exp-10-kid-never-sees-parent-controls) | No kid menu; remote can pause then double-press exit; idle shows IP | Partial | TV |
| 22 | [SS-DSN-01](design.md#ss-dsn-01-tv-quiz-is-four-huge-choices-nothing-else) | 2×2 tiles exist; still “Question N of M”, pause, FITB grid | Partial | TV |
| 23 | [SS-CNT-05](content.md#ss-cnt-05-admin-loads-the-bank-without-curl) | Question CRUD exists; bank load is still curl | Partial | Admin, Backend |
| 24 | [SS-REL-05](reliability.md#ss-rel-05-reboot-must-not-trap-the-kid-on-an-old-lock) | Replay works and strips callback; does not expire by duration | Partial | TV |
| 25 | [SS-BIZ-05](business-value.md#ss-biz-05-freemium-unlock-after-the-family-has-won-once) | Cap = 2; no paywall (Trial prompt is “update class”) | Partial | Mobile, Backend |
| 26 | [SS-QLT-04](quality-and-speed.md#ss-qlt-04-thin-tv-checklist-on-every-tv-pr) | No PR template | Not in code | TV |
| 27 | [SS-QLT-05](quality-and-speed.md#ss-qlt-05-privacy-safe-activation-telemetry) | No analytics | Not in code | Backend, Mobile |
| 28 | [SS-BIZ-01](business-value.md#ss-biz-01-time-to-first-quiz-is-the-north-star) | No funnel measurement | Not in code | All |
| 29 | [SS-DSN-05](design.md#ss-dsn-05-living-room-contrast-and-d-pad-focus) | Focus scale exists; no overscan/contrast pass | Partial | TV |
| 30 | [SS-DSN-06](design.md#ss-dsn-06-bilingual-labels-icon-short-word) | Review is icon-only by design today | Partial | Mobile |
| 31 | [SS-CNT-04](content.md#ss-cnt-04-local-life-in-evs-examples) | Some India flavour; EVS still generic science | Partial | Backend |
| 32 | [SS-BIZ-04](business-value.md#ss-biz-04-low-end-android-is-the-default-device) | minSdk 24/23; no size budget or cheap-device CI | Partial | Mobile, TV |
| 33 | [SS-BIZ-06](business-value.md#ss-biz-06-apk-share-path-for-places-play-is-painful) | No install picture-guide | Not in code | Mobile, TV |
| 34 | [SS-QLT-03](quality-and-speed.md#ss-qlt-03-cheap-phone-cheap-tv-in-ci-and-in-the-room) | No device-lab ritual in repo | Practice | Team |
| 35 | [SS-QLT-02](quality-and-speed.md#ss-qlt-02-definition-of-done-includes-a-rural-parent-pass) | Working agreement | Practice | Team |
| 36 | [SS-QLT-06](quality-and-speed.md#ss-qlt-06-weekly-tv-demo-and-small-slices) | Cadence | Practice | Team |

## Done in code — do not pick as new work

| ID | What shipped | Watch-out |
|----|----------------|-----------|
| [SS-EXP-01](experience.md#ss-exp-01-three-steps-to-first-quiz) | First-run Home is a 1 Add child → 2 Find TV → 3 Start quiz stepper until the first quiz; returning users get a "Start quiz" CTA on Home; `hasCompletedFirstQuiz` gates it | Hiding ProfData fully is SS-DSN-03 |
| [SS-EXP-02](experience.md#ss-exp-02-pair-the-tv-without-typing-an-ip) | TV shows a persisted 4-digit pairing code (huge) on idle; advertised via NSD `PAIR_CODE` TXT and verified with a non-persisted `PAIR_CODE_CHECK` probe; phone connects by TV name or types the code (numeric keypad); manual IP hidden behind "Need help?" in Library, first-run stepper, and Connected TVs | Two protocol copies still exist (contract test: SS-QLT-01); Used TVs that don't advertise/answer still need IP |
| [SS-REL-01](reliability.md#ss-rel-01-the-result-always-lands-on-the-right-kid) | `kidName` on command + result (mobile and TV); `checkSavedLock` strips stale callback | Backend `quiz_results` still keyed by **name**, not child id |
| [SS-BIZ-03](business-value.md#ss-biz-03-school-syllabus-trust-without-a-brochure) | Bundles carry `className` / `boardCode` / `subjects` | Pack cards still say “Freemium {category}” (copy: SS-EXP-05) |

Related **already shipped** (not separate leftover stories): guest login, NSD discovery, Kid Detail charts, read-lock/TTS/fast-answer/greeting/mascot, 👍👎🚩 API, 2 quizzes × 10 questions, 7s HTTP timeout, offline Room queues, admin question editor + blacklist, default Kid 1/Trial.

## Suggested next slice

Do **not** start pictures, paywall, or OTP until this path is obvious on a cheap phone + cheap stick:

1. Hide ProfData; rename Library buttons (SS-EXP-05, SS-DSN-03).
2. First-run: child (or skip Kid 1) → pick discovered TV by **name** → Start quiz (SS-EXP-01, SS-EXP-02).
3. Idle TV: Ready to play + name, IP in the footer (SS-DSN-07).
4. Move catalog seed off the request path (SS-REL-02).

## Groups

| Group | File |
|-------|------|
| Experience | [experience.md](experience.md) |
| Design | [design.md](design.md) |
| Business value | [business-value.md](business-value.md) |
| Reliability | [reliability.md](reliability.md) |
| Content | [content.md](content.md) |
| Quality and speed | [quality-and-speed.md](quality-and-speed.md) |
| Audit notes | [code-audit.md](code-audit.md) |
