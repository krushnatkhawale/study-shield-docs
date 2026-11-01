# Product backlog

The live queue is one file per feature under `current/`, `implemented/`, and `rejected/`. To implement one, tell a developer agent to refer to [llm-brief.md](llm-brief.md) and implement that `FEAT-<id>` from the current backlog.

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

On a feature file, `status` is Backlog, In Progress, or Implemented. `review` is empty, or Reject. A human is the only one who sets Reject.

## Live files (2026-11-01)

One file is one feature. The id is the filename. `legacy_id` is the old SS card, kept so a search still finds it. Components are the repos to open for that feature. For study-shield, mobile and tv name the Gradle module. The Friday job counts files in `current/`. It does not read this table.

| Folder | Id | Legacy | Name | Components |
|--------|----|--------|------|------------|
| current | [FEAT-1793475593348](current/FEAT-1793475593348.md) | SS-DSN-07 | Idle TV says ready to play; IP is secondary | study-shield (tv) |
| current | [FEAT-1793475593349](current/FEAT-1793475593349.md) | SS-DSN-03 | Mobile first-run has no hamburger maze | study-shield (mobile) |
| current | [FEAT-1793475593350](current/FEAT-1793475593350.md) | SS-REL-02 | First quiz bundle in under two seconds | study-shield-backend |
| current | [FEAT-1793475593351](current/FEAT-1793475593351.md) | SS-CNT-01 | Short sessions; typed answers are not for young kids | study-shield (mobile, tv); study-shield-backend |
| current | [FEAT-1793475593352](current/FEAT-1793475593352.md) | SS-DSN-02 | Nursery/KG questions are pictures + voice | study-shield (mobile, tv); study-shield-backend |
| current | [FEAT-1793475593353](current/FEAT-1793475593353.md) | SS-QLT-01 | One schema for TV ↔ mobile commands | study-shield (mobile, tv) |
| current | [FEAT-1793475593354](current/FEAT-1793475593354.md) | SS-REL-04 | Offline is a sentence, not a spinner | study-shield (mobile) |
| current | [FEAT-1793475593355](current/FEAT-1793475593355.md) | SS-CNT-02 | Reported questions reach a human the same day | study-shield-backend; study-shield-backend-admin |
| current | [FEAT-1793475593356](current/FEAT-1793475593356.md) | SS-DSN-04 | Mascot is present during the quiz, not only at the end | study-shield (tv) |
| current | [FEAT-1793475593357](current/FEAT-1793475593357.md) | SS-REL-03 | Same Wi-Fi in one picture | study-shield (mobile) |
| current | [FEAT-1793475593358](current/FEAT-1793475593358.md) | SS-BIZ-02 | WhatsApp share of a win | study-shield (mobile) |
| current | [FEAT-1793475593359](current/FEAT-1793475593359.md) | SS-CNT-03 | Hindi subject uses Hindi script | study-shield (mobile, tv); study-shield-backend |
| current | [FEAT-1793475593360](current/FEAT-1793475593360.md) | SS-EXP-11 | Numeric PIN, not email recovery | study-shield (mobile) |
| current | [FEAT-1793475593361](current/FEAT-1793475593361.md) | SS-EXP-09 | Shared phone, second adult | study-shield (mobile) |
| current | [FEAT-1793475593362](current/FEAT-1793475593362.md) | SS-EXP-10 | Kid never sees parent controls | study-shield (tv) |
| current | [FEAT-1793475593363](current/FEAT-1793475593363.md) | SS-DSN-01 | TV quiz is four huge choices, nothing else | study-shield (tv) |
| current | [FEAT-1793475593364](current/FEAT-1793475593364.md) | SS-CNT-05 | Admin loads the bank without curl | study-shield-backend-admin |
| current | [FEAT-1793475593365](current/FEAT-1793475593365.md) | SS-REL-05 | Reboot must not trap the kid on an old lock | study-shield (tv) |
| current | [FEAT-1793475593366](current/FEAT-1793475593366.md) | SS-BIZ-05 | Freemium unlock after the family has won once | study-shield (mobile); study-shield-backend |
| current | [FEAT-1793475593367](current/FEAT-1793475593367.md) | SS-QLT-04 | Thin-TV checklist on every TV PR | study-shield (mobile, tv) |
| current | [FEAT-1793475593368](current/FEAT-1793475593368.md) | SS-QLT-05 | Privacy-safe activation telemetry | study-shield (mobile) |
| current | [FEAT-1793475593369](current/FEAT-1793475593369.md) | SS-BIZ-01 | Time-to-first-quiz is the north star | study-shield (mobile) |
| current | [FEAT-1793475593370](current/FEAT-1793475593370.md) | SS-DSN-05 | Living-room contrast and D-pad focus | study-shield (tv) |
| current | [FEAT-1793475593371](current/FEAT-1793475593371.md) | SS-DSN-06 | Bilingual labels: icon + short word | study-shield (mobile) |
| current | [FEAT-1793475593372](current/FEAT-1793475593372.md) | SS-CNT-04 | Local life in EVS examples | study-shield-backend |
| current | [FEAT-1793475593373](current/FEAT-1793475593373.md) | SS-BIZ-04 | Low-end Android is the default device | study-shield (mobile, tv) |
| current | [FEAT-1793475593374](current/FEAT-1793475593374.md) | SS-BIZ-06 | APK share path for places Play is painful | study-shield (mobile) |
| current | [FEAT-1793475593375](current/FEAT-1793475593375.md) | SS-QLT-03 | Cheap phone + cheap TV in CI and in the room | study-shield (mobile, tv); study-shield-backend |
| current | [FEAT-1793475593376](current/FEAT-1793475593376.md) | SS-QLT-02 | Definition of Done includes a rural-parent pass | study-shield (mobile, tv) |
| current | [FEAT-1793475593377](current/FEAT-1793475593377.md) | SS-QLT-06 | Weekly TV demo and small slices | study-shield (mobile) |
| current | [FEAT-1793475593378](current/FEAT-1793475593378.md) | SS-PROD-03 | Listing shape decision (one vs two listings) | study-shield (mobile, tv) |
| current | [FEAT-1793475593379](current/FEAT-1793475593379.md) | SS-PROD-02 | Upload key + signing config | study-shield (mobile, tv) |
| current | [FEAT-1793475593380](current/FEAT-1793475593380.md) | SS-PROD-09 | Release-mode network logging | study-shield (mobile) |
| current | [FEAT-1793475593381](current/FEAT-1793475593381.md) | SS-PROD-10 | Build-time backend endpoint configuration | study-shield (mobile) |
| current | [FEAT-1793475593382](current/FEAT-1793475593382.md) | SS-PROD-01 | Target SDK 36 for mobile | study-shield (mobile) |
| current | [FEAT-1793475593383](current/FEAT-1793475593383.md) | SS-PROD-04 | TV sensitive permissions + declarations | study-shield (tv) |
| current | [FEAT-1793475593384](current/FEAT-1793475593384.md) | SS-PROD-05 | Location request scoping (Wi-Fi discovery) | study-shield (mobile) |
| current | [FEAT-1793475593385](current/FEAT-1793475593385.md) | SS-PROD-06 | Cleartext traffic scoping | study-shield (mobile) |
| current | [FEAT-1793475593386](current/FEAT-1793475593386.md) | SS-PROD-11 | Release build hardening + release CI | study-shield (mobile, tv) |
| current | [FEAT-1793475593387](current/FEAT-1793475593387.md) | SS-PROD-07 | Signed AAB + pre-submission checklist | study-shield (mobile, tv) |
| current | [FEAT-1793475593388](current/FEAT-1793475593388.md) | SS-PROD-08 | Console paperwork (owner-side; LLM preps drafts) | study-shield (mobile, tv) |
| implemented | [FEAT-1793475593389](implemented/FEAT-1793475593389.md) | SS-REL-01 | The result always lands on the right kid | study-shield (mobile, tv) |
| implemented | [FEAT-1793475593390](implemented/FEAT-1793475593390.md) | SS-BIZ-03 | School-syllabus trust without a brochure | study-shield (mobile) |
| implemented | [FEAT-1793475593391](implemented/FEAT-1793475593391.md) | SS-EXP-04 | Performance in plain words, not charts-first | study-shield (mobile) |
| implemented | [FEAT-1793475593392](implemented/FEAT-1793475593392.md) | SS-EXP-05 | Hide engineering words | study-shield (mobile, tv) |
| implemented | [FEAT-1793475593393](implemented/FEAT-1793475593393.md) | SS-EXP-06 | Pick the child by age and photo, not board jargon | study-shield (mobile) |
| implemented | [FEAT-1793475593394](implemented/FEAT-1793475593394.md) | SS-EXP-07 | Voice walkthrough for setup | study-shield (mobile) |
| implemented | [FEAT-1793475593395](implemented/FEAT-1793475593395.md) | SS-EXP-08 | One-tap play again for the same child | study-shield (mobile) |
| rejected | [FEAT-1793475593396](rejected/FEAT-1793475593396.md) | SS-EXP-01 | Three steps to first quiz | study-shield (mobile) |
| rejected | [FEAT-1793475593397](rejected/FEAT-1793475593397.md) | SS-EXP-02 | Pair the TV without typing an IP | study-shield (mobile, tv) |
| rejected | [FEAT-1793475593398](rejected/FEAT-1793475593398.md) | SS-EXP-03 | App speaks the parent's language | study-shield (mobile) |

## Suggested next slice

Do not start pictures, paywall, or OTP until this path is obvious on a cheap phone and a cheap stick:

1. Idle TV says ready to play, with the IP in the footer: [FEAT-1793475593348](current/FEAT-1793475593348.md).
2. Hide ProfData on first run: [FEAT-1793475593349](current/FEAT-1793475593349.md).
3. Move catalog seed off the request path: [FEAT-1793475593350](current/FEAT-1793475593350.md).

Pairing by room code and the three-step first-run stepper stay in `rejected/`.
