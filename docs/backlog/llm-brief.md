# How to implement a feature from the current backlog

The work to pick up is a file in [`current/`](current/). Each file is one feature, named `FEAT-<epoch-ms>.md`. The older SS-* pages stay as the long briefs. Do not delete them. Do not move a FEAT file to `implemented/` or `rejected/` yourself.

Say this to a developer agent:

> Refer to llm-brief and implement `<FEAT-id>` from the current backlog.

If no id is given, implement the lowest id in `docs/backlog/current/` (that is rank 1) and name it before writing code.

## What the agent must read first (local)

| Checkout | What it is |
|----------|------------|
| `/Users/hulk/.buzz/REPOS/study-shield` | Android Studio project: Gradle modules **`mobile/`** (parent) and **`tv/`** (kid) |
| `/Users/hulk/.buzz/REPOS/study-shield-backend` | Spring Boot modulith API (`ss-modulith/`) |
| `/Users/hulk/.buzz/REPOS/study-shield-backend-admin` | Vaadin admin (`app/`) |
| `/Users/hulk/.buzz/REPOS/study-shield-docs` | This docs site only — not runtime |

Architecture in this site: [system](../architecture/system.md), [mobile & TV](../architecture/mobile-tv.md), [backend](../architecture/backend.md). Screen flows in the app repo: `study-shield/docs/SCREEN_FLOWS_MOBILE.md`, `SCREEN_FLOWS_TV.md`.

## Invariants — never violate

1. **TV has no HTTP client.** It does not call the backend. Quiz JSON and results travel **Mobile ↔ TV on the LAN**.
2. **Socket pattern:** TV listens `ServerSocket(8888)`. Mobile sends `InterruptionCommand` (includes `mobileIp` + `resultCallbackPort`). TV opens a socket back and sends `QuizResultMessage`.
3. **Two copies of the protocol.** `InterruptionCommand` / `QuizResultMessage` live in:
   - `study-shield/mobile/src/main/java/com/kaushalya/interrupter/data/Models.kt`
   - `study-shield/tv/src/main/java/com/kaushalya/interrupter/InterruptionCommand.kt`  
   Any new field must be added to **both**, forwarded through `TvServerService` intent extras, and handled in TV `MainActivity`.
4. **Parent initiates; kid plays.** Settings, catalogs, pairing, paywalls stay on **mobile** (or admin). Do not add menus, login, or browsing on TV.
5. **Result attribution** uses `kidName` on the command and the result. TV `checkSavedLock()` must keep stripping stale `mobileIp` / `resultCallbackPort`.
6. After UI changes, update `SCREEN_FLOWS_*.md` in `study-shield/docs/`.

## How a card is structured

- **Code status** — Not in code / Partial / Done.
- **Work type** — *New* or *Enhance existing* (name the existing behaviour).
- **Repos / files** — where to edit.
- **Current behaviour** — what the code does now.
- **Change to** — the outcome.
- **Implementation pointers** — classes, patterns, tests to start from.
- **Do not** — thickness and scope traps.
- **Verify** — commands and a demo.

JDK for Android: Corretto 21 (`JAVA_HOME` as in [mobile & TV](../architecture/mobile-tv.md)). Backend: `./gradlew :ss-modulith:test`.

---

## Implement one current-backlog feature

```
Refer to llm-brief and implement FEAT-<id> from the current backlog.

Checkouts:
- /Users/hulk/.buzz/REPOS/study-shield                 (mobile/ + tv/)
- /Users/hulk/.buzz/REPOS/study-shield-backend
- /Users/hulk/.buzz/REPOS/study-shield-backend-admin
- /Users/hulk/.buzz/REPOS/open-school
- /Users/hulk/.buzz/REPOS/study-shield-docs           (the feature file lives here)

Before any code:
1. Read docs/backlog/llm-brief.md through the invariants.
2. Open docs/backlog/current/FEAT-<id>.md. If the id was not given, use the lowest FEAT id in that folder and say which one you are implementing.
3. Read the SS card named in that file's source field, from the heading through Verify. The FEAT file is the assignment. The SS card is the file list and the verify command.
4. If the FEAT file is not in current/, stop.

While you work:
A. Change only the repos named in components. Obey the invariants.
B. Verify with the SS card's Verify section.
C. If UI changed, update study-shield/docs/SCREEN_FLOWS_MOBILE.md and/or SCREEN_FLOWS_TV.md.
D. Use a branch whose name contains the exact id, for example feat/FEAT-<id>.
E. The pull request title must contain the exact id, for example "FEAT-<id>: <feature name>".
F. Do not set the FEAT file to Implemented. Do not move it to implemented/ or rejected/. A merged pull request whose title or branch contains that id is what moves it later.
G. Do not edit the SS-* pages. Do not delete a story.

Do not push unless asked. If Verify fails, stop and report. Do not start a second feature in the same run.
```

A human sets `review: Reject` on a current file to park it. Do not set that yourself.
