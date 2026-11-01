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

## Live files (2026-11-02)

One file is one feature. The id is the filename. `legacy_id` is the old SS card, kept so a search still finds it. Components are the repos to open for that feature. For study-shield, mobile and tv name the Gradle module. The Friday job counts files in `current/`. It does not read this table.

| Folder | Id | Legacy | Name | Components |
|--------|----|--------|------|------------|
| current | [FEAT-1793560481378](current/FEAT-1793560481378.md) |  | Quiz Setup Select sends that quiz | study-shield (mobile) |
| current | [FEAT-1793560481379](current/FEAT-1793560481379.md) |  | Prod boot validates the profile schema | study-shield-backend |
| current | [FEAT-1793560481380](current/FEAT-1793560481380.md) |  | Reject a user email that is not an email | study-shield-backend |
| current | [FEAT-1793562293589](current/FEAT-1793562293589.md) |  | Parent login must not write the question bank | study-shield (mobile); study-shield-backend |
| current | [FEAT-1793562293592](current/FEAT-1793562293592.md) |  | Prod profile hides API docs and health details | study-shield-backend |
| current | [FEAT-1793562293595](current/FEAT-1793562293595.md) |  | Admin boot must not alter the product database | study-shield-backend-admin |
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

1. Quiz Setup Select sends that quiz: [FEAT-1793560481378](current/FEAT-1793560481378.md).
2. Prod boot validates the profile schema: [FEAT-1793560481379](current/FEAT-1793560481379.md).
3. Reject a user email that is not an email: [FEAT-1793560481380](current/FEAT-1793560481380.md).

Pairing by room code and the three-step first-run stepper stay in `rejected/`.
