# How to feed a story to Buzz (bigpickle / muse)

Each backlog card below is written as a **self-contained implementation brief**. Copy **one story** (heading through “Verify”) into the agent. Do not paste the whole backlog.

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

## Run a list of stories in Buzz (copy this)

Paste the block below into a Buzz agent (bigpickle / muse). Replace the story IDs.

```
Implement StudyShield backlog stories IN ORDER, one at a time, then mark each DONE in the docs.

Stories (do not skip or reorder unless a later story is blocked by an earlier one you cannot finish):
1. SS-EXP-05
2. SS-DSN-07

Nest / checkouts:
- /Users/hulk/.buzz/REPOS/study-shield          (mobile/ + tv/)
- /Users/hulk/.buzz/REPOS/study-shield-backend
- /Users/hulk/.buzz/REPOS/study-shield-backend-admin
- /Users/hulk/.buzz/REPOS/study-shield-docs     (backlog lives here)

Before ANY code:
1. Read study-shield-docs/docs/backlog/llm-brief.md (invariants).
2. Open study-shield-docs/docs/backlog/index.md, find each ID, follow the link, read the FULL card from heading through Verify.
3. If Code status is already "Done in code", skip implementation; still confirm and note it.
4. Practice stories (SS-QLT-02, SS-QLT-03, SS-QLT-06) are process — only add the files the card names (e.g. PR template). Do not invent product features.

For EACH story, in order:
A. Implement only that story. Repos/files are on the card. Partial = enhance named existing behaviour. Not in code = add in the named modules. Do not start the next story until this one is verified.
B. Obey invariants: TV has no HTTP; InterruptionCommand/QuizResultMessage exist in BOTH mobile Models.kt AND tv InterruptionCommand.kt; parent initiates, kid plays; keep kidName + checkSavedLock callback strip.
C. Verify using the card's Verify section (Gradle assemble/test as named).
D. Update screen flows if UI changed: study-shield/docs/SCREEN_FLOWS_MOBILE.md and/or SCREEN_FLOWS_TV.md.
E. Mark the story DONE in study-shield-docs BEFORE starting the next ID:
   - On the story card: set **Code status** to **Done in code (IMPLEMENTED)**. Add a short **Implemented** line: date, repos/files touched, how it was verified. Keep the old "Current behaviour" as history or replace with "Shipped: …".
   - In docs/backlog/index.md: remove the row from "Remaining work"; add it under "Done in code" with a one-line watch-out if needed.
   - In docs/backlog/code-audit.md: move the ID into Done; drop it from Not in code / Partial counts if you update the scoreboard.
F. Stop that story. Then start the next ID from step A.

If a story fails Verify or is blocked: mark it **Partial** (not Done), write what shipped vs what is left on the card, skip to the next ID only if the user said to continue on failure. Default: STOP the queue and report.

Do not push unless I ask. Do not implement stories that are not in the list.
```

### How the agent must mark DONE

| File | Edit |
|------|------|
| Story card (`experience.md`, `design.md`, …) | `**Code status**` → `**Done in code (IMPLEMENTED)**`. Add **Implemented (YYYY-MM-DD):** files + verify command. |
| `docs/backlog/index.md` | Move the ID from **Remaining work** to **Done in code**. |
| `docs/backlog/code-audit.md` | Adjust scoreboard if you maintain counts. |

Do not delete the story. Done cards stay as the record of what shipped.
