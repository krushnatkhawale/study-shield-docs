# Product backlog — UX value, by role

Refined requirements for the StudyShield product family. Stories are written from the
people who actually use the system, then ordered by **time-to-first-success** and
**trust**. They are not a dump of features.

This is the working backlog for an agile team. Implementation still lives in the app
repos; this site is the shared refinement surface.

## Product constraints (do not violate)

| Constraint | Meaning |
|------------|---------|
| **TV stays thin** | The kid only *plays*. No login, no settings, no catalogs, no HTTP to the backend. Remote + big pictures + sound. |
| **TV is for kids** | Short, loud-enough, personal, game-like. Not a test paper. Not a dashboard. |
| **Mobile is for parents** | Especially rural households: school-educated but not app-fluent, mixed English, shared cheap Android, WhatsApp-first. Setup and results must work without a manual. |
| **Mobile is the hub** | TV never talks to the backend. Quiz content and results always go Mobile ↔ Backend and Mobile ↔ TV (LAN). |
| **Apps** | `study-shield` (mobile + TV), `study-shield-backend`, `study-shield-backend-admin`. |

If a story makes the TV app "smarter" by adding menus, accounts, or browsing, **reject it**.
Put that work on mobile or admin.

## Roles

| Role | Primary surface | What they care about |
|------|-----------------|----------------------|
| **Kid** (Nursery–Class 10) | TV | Fun, being named, finishing fast, praise. Cannot read much at younger ages. |
| **Parent** (primary, often rural) | Mobile | "Start a quiz for my child" and "did they do well?" without English jargon. |
| **Second parent / grandparent** | Mobile (shared phone) | Same tasks, no extra account maze. |
| **Content author** | Backend bank + admin | Age-right questions, Hindi/English, fix bad items. |
| **Operator / admin** | `study-shield-backend-admin` | Load content, see reports, flip catalog flags without SSH. |
| **Engineering team** | All repos | Quality and speed: contracts, devices, DoD, CI, small slices. |

## How to read a story

Every story has: **ID**, **priority** (P0 / P1 / P2), **role**, **apps**, **component**,
user story, why it matters, acceptance checks, and an explicit **not this** so TV
thinness and parent simplicity are not "interpreted away".

| Priority | Meaning |
|----------|---------|
| **P0** | Blocks first success or trust. Next 1–2 sprints. |
| **P1** | Multiplies delight, language, or retention after first quiz works. |
| **P2** | Valuable later; do not start before P0 activation is real on cheap devices. |

## Groups

| Group | File | What it holds |
|-------|------|----------------|
| Experience | [experience.md](experience.md) | How parent and kid *get through* setup, quiz, results |
| Design | [design.md](design.md) | 10-foot TV, large-tap mobile, picture+voice, progressive disclosure |
| Business value | [business-value.md](business-value.md) | Activation, trust, word-of-mouth, freemium, low-end India |
| Reliability | [reliability.md](reliability.md) | Pairing, lost results, slow first bundle, offline, cheap Wi-Fi |
| Content | [content.md](content.md) | Short sessions, pictures, real Hindi, reported-question loop |
| Quality and speed | [quality-and-speed.md](quality-and-speed.md) | DoD, contracts, device lab, CI, telemetry, agile habits |

## Suggested sprint order (global)

Work **down this list**. It already mixes groups so the team does not "finish design
while pairing is still an IP address".

| Rank | ID | Story | Priority | Apps | Group |
|------|----|-------|----------|------|-------|
| 1 | [SS-EXP-01](experience.md#ss-exp-01-three-steps-to-first-quiz) | Three steps to first quiz | P0 | Mobile | Experience |
| 2 | [SS-EXP-02](experience.md#ss-exp-02-pair-the-tv-without-typing-an-ip) | Pair the TV without typing an IP | P0 | Mobile, TV | Experience |
| 3 | [SS-DSN-01](design.md#ss-dsn-01-tv-quiz-is-four-huge-choices-nothing-else) | TV quiz is four huge choices | P0 | TV | Design |
| 4 | [SS-REL-01](reliability.md#ss-rel-01-the-result-always-lands-on-the-right-kid) | Result always lands on the right kid | P0 | Mobile, TV, Backend | Reliability |
| 5 | [SS-REL-02](reliability.md#ss-rel-02-first-quiz-bundle-in-under-two-seconds) | First quiz bundle in under two seconds | P0 | Backend, Mobile | Reliability |
| 6 | [SS-EXP-03](experience.md#ss-exp-03-app-speaks-the-parents-language) | App speaks the parent's language | P0 | Mobile | Experience |
| 7 | [SS-EXP-04](experience.md#ss-exp-04-performance-in-plain-words-not-charts-first) | Performance in plain words | P0 | Mobile | Experience |
| 8 | [SS-DSN-02](design.md#ss-dsn-02-nurserykg-questions-are-pictures-voice) | Nursery/KG = pictures + voice | P0 | Mobile, TV, Backend | Design |
| 9 | [SS-CNT-01](content.md#ss-cnt-01-short-sessions-typed-answers-are-not-for-young-kids) | Short sessions; no typing for young kids | P0 | TV, Backend | Content |
| 10 | [SS-EXP-05](experience.md#ss-exp-05-hide-engineering-words) | Hide engineering words | P0 | Mobile, TV | Experience |
| 11 | [SS-QLT-01](quality-and-speed.md#ss-qlt-01-one-schema-for-tv-mobile-commands) | One schema for TV ↔ mobile commands | P0 | Mobile, TV | Quality |
| 12 | [SS-QLT-02](quality-and-speed.md#ss-qlt-02-definition-of-done-includes-a-rural-parent-pass) | DoD includes a rural-parent pass | P0 | Team | Quality |
| 13 | [SS-EXP-06](experience.md#ss-exp-06-pick-the-child-by-age-and-photo-not-board-jargon) | Pick child by age and photo | P1 | Mobile | Experience |
| 14 | [SS-DSN-03](design.md#ss-dsn-03-mobile-first-run-has-no-hamburger-maze) | First-run has no hamburger maze | P1 | Mobile | Design |
| 15 | [SS-EXP-07](experience.md#ss-exp-07-voice-walkthrough-for-setup) | Voice walkthrough for setup | P1 | Mobile | Experience |
| 16 | [SS-BIZ-01](business-value.md#ss-biz-01-time-to-first-quiz-is-the-north-star) | Time-to-first-quiz is the north star | P1 | All | Business |
| 17 | [SS-BIZ-02](business-value.md#ss-biz-02-whatsapp-share-of-a-win) | WhatsApp share of a win | P1 | Mobile | Business |
| 18 | [SS-DSN-04](design.md#ss-dsn-04-mascot-is-present-during-the-quiz-not-only-at-the-end) | Mascot during the quiz | P1 | TV | Design |
| 19 | [SS-REL-03](reliability.md#ss-rel-03-same-wi-fi-in-one-picture) | Same Wi-Fi in one picture | P1 | Mobile, TV | Reliability |
| 20 | [SS-CNT-02](content.md#ss-cnt-02-reported-questions-reach-a-human-the-same-day) | Reported questions reach a human | P1 | Admin, Backend, Mobile | Content |
| 21 | [SS-QLT-03](quality-and-speed.md#ss-qlt-03-cheap-phone-cheap-tv-in-ci-and-in-the-room) | Cheap phone + cheap TV in the loop | P1 | Team | Quality |
| 22 | [SS-EXP-08](experience.md#ss-exp-08-one-tap-play-again-for-the-same-child) | One-tap play again | P1 | Mobile, TV | Experience |
| 23 | [SS-BIZ-03](business-value.md#ss-biz-03-school-syllabus-trust-without-a-brochure) | School-syllabus trust | P1 | Mobile, Backend | Business |
| 24 | [SS-REL-04](reliability.md#ss-rel-04-offline-is-a-sentence-not-a-spinner) | Offline is a sentence, not a spinner | P1 | Mobile | Reliability |
| 25 | [SS-DSN-05](design.md#ss-dsn-05-living-room-contrast-and-d-pad-focus) | Living-room contrast and D-pad focus | P1 | TV | Design |
| 26 | [SS-EXP-09](experience.md#ss-exp-09-shared-phone-second-adult) | Shared phone, second adult | P1 | Mobile, Backend | Experience |
| 27 | [SS-CNT-03](content.md#ss-cnt-03-hindi-subject-uses-hindi-script) | Hindi subject uses Hindi script | P1 | Backend, TV, Mobile | Content |
| 28 | [SS-QLT-04](quality-and-speed.md#ss-qlt-04-thin-tv-checklist-on-every-tv-pr) | Thin-TV checklist on every TV PR | P1 | TV | Quality |
| 29 | [SS-BIZ-04](business-value.md#ss-biz-04-low-end-android-is-the-default-device) | Low-end Android is the default device | P1 | Mobile, TV | Business |
| 30 | [SS-EXP-10](experience.md#ss-exp-10-kid-never-sees-parent-controls) | Kid never sees parent controls | P1 | TV | Experience |
| 31 | [SS-DSN-06](design.md#ss-dsn-06-bilingual-labels-icon-short-word) | Bilingual labels: icon + short word | P2 | Mobile | Design |
| 32 | [SS-BIZ-05](business-value.md#ss-biz-05-freemium-unlock-after-the-family-has-won-once) | Freemium unlock after a win | P2 | Mobile, Backend | Business |
| 33 | [SS-REL-05](reliability.md#ss-rel-05-reboot-must-not-trap-the-kid-on-an-old-lock) | Reboot must not trap the kid | P2 | TV | Reliability |
| 34 | [SS-CNT-04](content.md#ss-cnt-04-local-life-in-evs-examples) | Local life in EVS examples | P2 | Backend | Content |
| 35 | [SS-QLT-05](quality-and-speed.md#ss-qlt-05-privacy-safe-activation-telemetry) | Privacy-safe activation telemetry | P2 | Backend, Mobile | Quality |
| 36 | [SS-EXP-11](experience.md#ss-exp-11-numeric-pin-not-email-recovery) | Numeric PIN, not email recovery | P2 | Mobile | Experience |
| 37 | [SS-DSN-07](design.md#ss-dsn-07-idle-tv-says-ready-to-play-ip-is-secondary) | Idle TV says ready to play | P2 | TV | Design |
| 38 | [SS-BIZ-06](business-value.md#ss-biz-06-apk-share-path-for-places-play-is-painful) | APK share path | P2 | Mobile, TV | Business |
| 39 | [SS-QLT-06](quality-and-speed.md#ss-qlt-06-weekly-tv-demo-and-small-slices) | Weekly TV demo and small slices | P2 | Team | Quality |
| 40 | [SS-CNT-05](content.md#ss-cnt-05-admin-loads-the-bank-without-curl) | Admin loads the bank without curl | P2 | Admin, Backend | Content |

## Suggested first slice (one sprint)

Ship **one** path that a rural parent can complete on a cheap phone and a cheap Android
TV stick, in Hindi or Marathi, without help:

1. Open mobile → add child (name + age) → phone finds TV → start quiz.
2. Kid answers with the remote on four big buttons; hears the question; sees the mascot.
3. Parent sees "Rohan did well — 8 out of 10" on the phone.

That slice is SS-EXP-01, SS-EXP-02, SS-DSN-01, SS-REL-01, SS-EXP-04, SS-CNT-01.
Everything else waits until this path is boringly reliable.

## Story writing rules for this team

- One user-visible outcome per story. Split technical enablement into a linked P0
  reliability/quality story rather than hiding it in the UX card.
- Name the **apps** (`study-shield` mobile / `study-shield` TV / `study-shield-backend` /
  `study-shield-backend-admin`) when more than one moves.
- Write acceptance as something you can demo on a real TV.
- Prefer deleting a screen over adding a tooltip.
- Content and pairing bugs beat new charts.
