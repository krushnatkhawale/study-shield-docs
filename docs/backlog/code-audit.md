# How this backlog was written — then checked against code

Stories are now **paste-ready implementation briefs** ([llm-brief.md](llm-brief.md)): each names repos, files, current code, and whether to **enhance** or **add**.

Checked against local checkouts on **2026-09-09**:

- `/Users/hulk/.buzz/REPOS/study-shield` (mobile + TV)
- `/Users/hulk/.buzz/REPOS/study-shield-backend`
- `/Users/hulk/.buzz/REPOS/study-shield-backend-admin`

## Original thinking (first draft)

The first stories were **not** a "this is unimplemented" list.

They came from **requirement refinement for two people**:

1. A **kid on Android TV** — thin, remote-only, game-like.
2. A **parent who can use WhatsApp** but will bounce off IP addresses, English jargon, and a drawer of nine screens.

Inputs were this docs site, screen-flow markdown, ADRs, and those constraints — **not** a file-by-file pass over Kotlin/Java. That was the wrong order for a team whose code is ahead of the docs.

So several cards described work that **already shipped** (result `kidName`, NSD discovery, guest login, read-lock/TTS, mascot on results, feedback API, 2 quizzes per class, 7s timeouts, offline queues). Others mixed "keep this" with "build this".

## What we did instead

Each story now has **Code status**:

| Status | Meaning |
|--------|---------|
| **Done in code** | Behaviour exists. Do not rebuild. Protect with tests if thin. |
| **Partial** | Pieces exist; the *parent/kid outcome* in the story is still missing. |
| **Not in code** | Genuine new work. |
| **Practice** | Team habit (DoD, demo). Not a feature. |

Evidence is paths in those three repos. Docs (`SCREEN_FLOWS_*.md`, ADRs) were treated as hints only.

## Scoreboard

| Status | Count | IDs |
|--------|------:|-----|
| Done in code | 7 | SS-EXP-04 (Kid Detail/Results/Kids lead with plain-words band sentence; charts under "See more"), SS-EXP-05 (jargon-free copy: TV app_name, NSD device name, Start on TV/Unlock TV, plain pack labels), SS-EXP-06 (age-labelled class chips; syllabus off on first add), SS-EXP-07 (on-device TTS: `SetupTts.kt` + `speakSetupSteps`), SS-EXP-08 (one-tap play again: reuses last kid/TV/pack with shuffled options), SS-REL-01 (TV↔mobile `kidName` + stale callback strip), SS-BIZ-03 (bundle has class/board/subject strings) |
| Partial | 17 | guest, TV D-pad, idle/IP, lock reboot, offline copy, bundle latency, FITB/length, feedback inbox, EVS, admin load, freemium cap, low-end SDK, mascot timing, contrast, review icons, Wi-Fi copy, contract tests (backend JSON only) |
| Not in code | 12 | PIN (dummy switch), pictures on TV, drawer IA, WhatsApp share, paywall, APK guide, Hindi script, telemetry, shared command schema tests, PR template, parent-app i18n, SS-EXP-03 (reverted: language picker + multi-locale removed; app English-only) |
| Reverted / parked | 2 | SS-EXP-01 (first-run stepper + Home CTA gate), SS-EXP-02 (pair-code pairing) — reverted together 2026-09-11, pre-OTP IP flow restored (K.t.: pairing required multicast his router filters) |
| Practice | 2 | SS-QLT-02, SS-QLT-06 |

SS-REL-01 is **done on the wire** (both Android copies send/echo `kidName`; TV replay strips `mobileIp` / `resultCallbackPort`). Backend results are still keyed by **child name string**, not `childProfileId` — that leftover sits under the same card as a small follow-up, not a rebuild.

## Already in the product (do not reinvent)

These are easy to miss if you only read older design docs:

- Default **Kid 1 / Trial** on signup; Trial bank seeded from mobile on login.
- **NSD** `_interrupter._tcp` discovery by TV name; Remember TV per Wi-Fi.
- **Guest** login; parent-selection overlay; email/username + password (no OTP).
- Per-kid **read-lock, TTS, fast-answer threshold, greeting language, mascot**.
- TV **2×2 D-pad quiz**, True/False layout, results mascot + TTS, **4s auto-close**.
- **Fast-answer count** to parent only; Kid Detail **charts**.
- Question **👍👎🚩** + backend upsert; admin can **blacklist** a question.
- Freemium **2 quizzes per class**, **10 questions** each.
- Offline queues for results, kids, feedback; OkHttp **7s** timeout.
- Admin Vaadin: classes, subject order, quizzes, questions, users — **not** bank-load or feedback inbox.
- Admin Vaadin user management manages **both** audiences: client/mobile users (`/api/v1/users`, filtered to MOBILE/PARENT) and admin users (`/api/v1/admin-users`) via tabs on `/users`.

## Highest-value remaining work (from code, not from imagination)

1. **One obvious first path** — ⚠️ SS-EXP-01 **reverted 2026-09-11** (with SS-EXP-02): the first-run stepper + `hasCompletedFirstQuiz` Home gate are gone; Home is `StatsDashboardScreen` with the "Start quiz" CTA + SS-EXP-08 "Play again" retained. Parked for a future retry as a plain stepper.
2. **Pairing without IP as the hero** — ⚠️ SS-EXP-02 **reverted 2026-09-11**: `PairCodeStore`, `PAIR_CODE` NSD TXT, `PAIR_CODE_CHECK` probe, and code-entry UI removed via `git revert 2fa0614`; TV idle = "Interrupter Ready! 🚀" + IP, manual IP is the hero again. Root cause: OTP only matches multicast-discovered TVs and the field network filters mDNS — re-introduce only with a seeded/unicast channel.
3. **Parent language + copy** — ⚠️ SS-EXP-03 **reverted** 2026-09-10: language picker + `values-hi/` + `values-mr/` removed; app is English-only. SS-EXP-04 (plain-words performance) is still shipped. Language subjects will be implemented separately later.
4. **First bundle latency** — `ensureCatalogForClass` still runs on `POST /quiz-bundles` (TECH_DEBT TD-1). Startup seed default **off**.
5. **Nursery as pictures + 5 spoken questions** — bank is 10 text MCQ/TF; `imageUrl` is unused; auto-dictation **defaults off**.
6. **Contract test for duplicated `InterruptionCommand`** — two Kotlin copies, TV `QuizQuestion` has no `id`; no shared test.

Cheap wins that are still **Not in code**: dummy PIN switch.
