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
| 1 | [SS-DSN-07](design.md#ss-dsn-07-idle-tv-says-ready-to-play-ip-is-secondary) | Idle TV: “Interrupter Ready” + IP; no room code | Not in code | TV |
| 2 | [SS-DSN-03](design.md#ss-dsn-03-mobile-first-run-has-no-hamburger-maze) | Full drawer including **ProfData** after login | Not in code | Mobile |
| 3 | [SS-REL-02](reliability.md#ss-rel-02-first-quiz-bundle-in-under-two-seconds) | `ensureCatalogForClass` still on the request path (TD-1) | Partial | Backend, Mobile |
| 4 | [SS-CNT-01](content.md#ss-cnt-01-short-sessions-typed-answers-are-not-for-young-kids) | Quizzes are 10 questions; Library can still send FITB | Partial | TV, Backend, Mobile |
| 5 | [SS-DSN-02](design.md#ss-dsn-02-nurserykg-questions-are-pictures-voice) | No question images; auto-dictation defaults **off** | Not in code | Mobile, TV, Backend |
| 6 | [SS-QLT-01](quality-and-speed.md#ss-qlt-01-one-schema-for-tv-mobile-commands) | Two Kotlin copies; no contract test | Not in code | Mobile, TV |
| 7 | [SS-REL-04](reliability.md#ss-rel-04-offline-is-a-sentence-not-a-spinner) | Queues exist; parent copy is a toast, not a plain banner | Partial | Mobile |
| 8 | [SS-CNT-02](content.md#ss-cnt-02-reported-questions-reach-a-human-the-same-day) | Feedback API + blacklist exist; no admin inbox | Partial | Admin, Backend, Mobile |
| 9 | [SS-DSN-04](design.md#ss-dsn-04-mascot-is-present-during-the-quiz-not-only-at-the-end) | `LiveMascot` on results only | Partial | TV |
| 10 | [SS-REL-03](reliability.md#ss-rel-03-same-wi-fi-in-one-picture) | `NOT_ON_WIFI` for TTS probe only; no picture | Partial | Mobile |
| 11 | [SS-BIZ-02](business-value.md#ss-biz-02-whatsapp-share-of-a-win) | No share sheet | Not in code | Mobile |
| 12 | [SS-CNT-03](content.md#ss-cnt-03-hindi-subject-uses-hindi-script) | Hindi subject is English GK (documented D3) | Not in code | Backend, TV, Mobile |
| 13 | [SS-EXP-11](experience.md#ss-exp-11-numeric-pin-not-email-recovery) | Settings PIN switch is a no-op | Not in code | Mobile |
| 14 | [SS-EXP-09](experience.md#ss-exp-09-shared-phone-second-adult) | Guest works; overlay + email; no OTP; Add Parent is TODO | Partial | Mobile, Backend |
| 15 | [SS-EXP-10](experience.md#ss-exp-10-kid-never-sees-parent-controls) | No kid menu; remote can pause then double-press exit; idle shows IP | Partial | TV |
| 16 | [SS-DSN-01](design.md#ss-dsn-01-tv-quiz-is-four-huge-choices-nothing-else) | 2×2 tiles exist; still “Question N of M”, pause, FITB grid | Partial | TV |
| 17 | [SS-CNT-05](content.md#ss-cnt-05-admin-loads-the-bank-without-curl) | Question CRUD exists; bank load is still curl | Partial | Admin, Backend |
| 18 | [SS-REL-05](reliability.md#ss-rel-05-reboot-must-not-trap-the-kid-on-an-old-lock) | Replay works and strips callback; does not expire by duration | Partial | TV |
| 19 | [SS-BIZ-05](business-value.md#ss-biz-05-freemium-unlock-after-the-family-has-won-once) | Cap = 2; no paywall (Trial prompt is “update class”) | Partial | Mobile, Backend |
| 20 | [SS-QLT-04](quality-and-speed.md#ss-qlt-04-thin-tv-checklist-on-every-tv-pr) | No PR template | Not in code | TV |
| 21 | [SS-QLT-05](quality-and-speed.md#ss-qlt-05-privacy-safe-activation-telemetry) | No analytics | Not in code | Backend, Mobile |
| 22 | [SS-BIZ-01](business-value.md#ss-biz-01-time-to-first-quiz-is-the-north-star) | No funnel measurement | Not in code | All |
| 23 | [SS-DSN-05](design.md#ss-dsn-05-living-room-contrast-and-d-pad-focus) | Focus scale exists; no overscan/contrast pass | Partial | TV |
| 24 | [SS-DSN-06](design.md#ss-dsn-06-bilingual-labels-icon-short-word) | Review is icon-only by design today | Partial | Mobile |
| 25 | [SS-CNT-04](content.md#ss-cnt-04-local-life-in-evs-examples) | Some India flavour; EVS still generic science | Partial | Backend |
| 26 | [SS-BIZ-04](business-value.md#ss-biz-04-low-end-android-is-the-default-device) | minSdk 24/23; no size budget or cheap-device CI | Partial | Mobile, TV |
| 27 | [SS-BIZ-06](business-value.md#ss-biz-06-apk-share-path-for-places-play-is-painful) | No install picture-guide | Not in code | Mobile, TV |
| 28 | [SS-QLT-03](quality-and-speed.md#ss-qlt-03-cheap-phone-cheap-tv-in-ci-and-in-the-room) | No device-lab ritual in repo | Practice | Team |
| 29 | [SS-QLT-02](quality-and-speed.md#ss-qlt-02-definition-of-done-includes-a-rural-parent-pass) | Working agreement | Practice | Team |
| 30 | [SS-QLT-06](quality-and-speed.md#ss-qlt-06-weekly-tv-demo-and-small-slices) | Cadence | Practice | Team |

## Reverted / parked — do not pick as new work

| ID | What happened | Watch-out |
|----|----------------|-----------|
| [SS-EXP-01](experience.md#ss-exp-01-three-steps-to-first-quiz) | **Reverted 2026-09-11:** first-run 3-step stepper + `hasCompletedFirstQuiz` gate removed with the OTP pairing work (krushnat: the OTP path never worked on his network; pre-OTP flow restored). Home is `StatsDashboardScreen` again with the "Start quiz" CTA + SS-EXP-08 "Play again" retained. | Re-introduce as a plain stepper that calls existing screens; pairing (SS-EXP-02) is the parkable piece |
| [SS-EXP-02](experience.md#ss-exp-02-pair-the-tv-without-typing-an-ip) | **Reverted 2026-09-11:** `PairCodeStore`, `PAIR_CODE` TXT, `PAIR_CODE_CHECK`, `PairCodeMessage`, code entry UI all removed via `git revert 2fa0614`. TV idle = "Interrupter Ready! 🚀" + IP; manual IP is the primary connect path again. | Root cause of the failure: OTP only matches against multicast-discovered TVs and his router filters mDNS. Retry needs a seed/unicast channel, not multicast |
| [SS-EXP-03](experience.md#ss-exp-03-app-speaks-the-parents-language) | ~~Hindi/Marathi app chrome~~ **Reverted 2026-09-10:** language picker + `values-hi/` + `values-mr/` removed; app is English-only. Language subjects will be implemented separately later. | N/A — reverted |

## Done in code — do not pick as new work

| ID | What shipped | Watch-out |
|----|----------------|-----------|
| [SS-REL-01](reliability.md#ss-rel-01-the-result-always-lands-on-the-right-kid) | `kidName` on command + result (mobile and TV); `checkSavedLock` strips stale callback | Backend `quiz_results` still keyed by **name**, not child id |
| [SS-BIZ-03](business-value.md#ss-biz-03-school-syllabus-trust-without-a-brochure) | Bundles carry `className` / `boardCode` / `subjects` | Pack cards still say “Freemium {category}” (copy: SS-EXP-05) |
| [SS-EXP-04](experience.md#ss-exp-04-performance-in-plain-words-not-charts-first) | Kid Detail leads with a plain-words hero "Rohan did well — 8 out of 10" (bands did well / did OK / needs practice, EN/HI/MR); charts under "See more"; empty state gains "Start their first quiz"; Kids card + Results list use the same phrase | Band thresholds are a fixed ≥80 / 50–79 / <50 rule in code, not a percentile service |
| [SS-EXP-05](experience.md#ss-exp-05-hide-engineering-words) | Jargon-free copy: TV launcher "StudyShield", NSD shows the device name (type stays `_interrupter._tcp`), mobile Control = "Set up a session / Start on TV / Unlock TV", pack cards show the subject not "Freemium …" | Banned words still set *internal* protocol/class names (callback, socket, bundle) on purpose; only UI copy changed |
| [SS-EXP-06](experience.md#ss-exp-06-pick-the-child-by-age-and-photo-not-board-jargon) | Kid form class picker is age-labelled chips ("Nursery · age 3" … "Class 10 · age 15") using exact backend class names; birth year pre-selects the class; birth year optional (name+class required); syllabus only when editing (board `ALL` default) | First-run stepper was reverted with SS-EXP-01; the age-labelled chip grid itself still ships in the kid form |
| [SS-EXP-07](experience.md#ss-exp-07-voice-walkthrough-for-setup) | On-device TTS for first-run stepper: "Read steps aloud" toggle persists in `SessionManager.speakSetupSteps`; `SetupTts.kt` lifecycle helper speaks one sentence per step in EN/HI/MR; no network dependency; silent no-op if TTS unavailable | Toggle lived only on the first-run stepper (reverted 2026-09-11); `SetupTts.kt` + `speakSetupSteps` remain until the stepper returns |
| [SS-EXP-08](experience.md#ss-exp-08-one-tap-play-again-for-the-same-child) | "Play again for {name}" on Results (list top card + detail button) and Home CTA; `StudyViewModel.replayLastSession()` reuses last kid/TV/pack and re-shuffles options; routes to Connected TVs if no TV remembered | Replay uses the in-memory last pack; after process death the parent goes through Start quiz |

Related **already shipped** (not separate leftover stories): guest login, NSD discovery, Kid Detail charts, read-lock/TTS/fast-answer/greeting/mascot, 👍👎🚩 API, 2 quizzes × 10 questions, 7s HTTP timeout, offline Room queues, admin question editor + blacklist, default Kid 1/Trial.

## Suggested next slice

Do **not** start pictures, paywall, or OTP until this path is obvious on a cheap phone + cheap stick:

1. Hide ProfData; rename Library buttons (SS-EXP-05, SS-DSN-03).
2. First-run: child (or skip Kid 1) → connect by **IP** (or discovered TV name) → Start quiz. The OTP pairing stepper (SS-EXP-01/02) is parked pending a seeded/unicast pairing channel — multicast discovery is unreliable on the field network.
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