# Implement one feature from the current backlog

Say this to a developer agent. Replace the id with a file in `docs/backlog/current/`.

```
Refer to docs/backlog/llm-brief.md and implement FEAT-<id> from the current backlog.
```

The agent reads this page, then that one file. It does not paste an SS-* card. Those pages stay as the original briefs. The feature file is the work.

## What the agent must read first (local)

Open a code checkout only when the feature file names it.

| Checkout | What it is |
|----------|------------|
| `/Users/hulk/.buzz/REPOS/study-shield` | Android Studio project: Gradle modules **`mobile/`** (parent) and **`tv/`** (kid). `krushnatkhawale/study-shield` |
| `/Users/hulk/.buzz/REPOS/study-shield-backend` | Spring Boot modulith API (`ss-modulith/`). `krushnatkhawale/study-shield-backend` |
| `/Users/hulk/.buzz/REPOS/study-shield-backend-admin` | Vaadin admin (`app/`). `krushnatkhawale/study-shield-backend-admin` |
| `/Users/hulk/.buzz/REPOS/open-school` | Separate product. Open it only if the feature names it. |
| `/Users/hulk/.buzz/REPOS/study-shield-docs` | This docs site. The feature file lives here. |

Architecture: [system](../architecture/system.md), [mobile & TV](../architecture/mobile-tv.md), [backend](../architecture/backend.md). Screen flows in the app repo: `study-shield/docs/SCREEN_FLOWS_MOBILE.md`, `SCREEN_FLOWS_TV.md`.

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
7. Do not implement a file in `rejected/`. Do not clear `review`. A human does that.

JDK for Android: Corretto 21 (`JAVA_HOME` as in [mobile & TV](../architecture/mobile-tv.md)). Backend: `./gradlew :ss-modulith:test`.

## How a feature file is structured

Front matter: `id`, `name`, `legacy_id`, `scope`, `components`, `priority`, `effort`, `impact`, `release_phase`, `status`, `review`, `created`, `completed`, `source`.

Body:

- User story, with a persona from [index.md](index.md) (Kid, Parent, Second adult, Content author, Operator, Engineering)
- Technical context
- Two acceptance scenarios, one of them a failure case
- API / data contract impact, or None
- Testing requirements
- Card excerpts: paths and limits copied from the old SS card

`legacy_id` is only a search handle. The filename is the id that goes on the branch and the pull request.

## Run one feature

```
Refer to docs/backlog/llm-brief.md and implement FEAT-<id> from the current backlog.

Checkout for the feature file:
- /Users/hulk/.buzz/REPOS/study-shield-docs

Code checkouts, only if the feature names them:
- /Users/hulk/.buzz/REPOS/study-shield
- /Users/hulk/.buzz/REPOS/study-shield-backend
- /Users/hulk/.buzz/REPOS/study-shield-backend-admin
- /Users/hulk/.buzz/REPOS/open-school

Before any code:
1. Read study-shield-docs/docs/backlog/llm-brief.md (invariants).
2. Read study-shield-docs/docs/backlog/current/FEAT-<id>.md. If that file is missing, stop.
3. If status is Implemented, or review is Reject, stop. Do not look for a substitute id.

Then:
A. Implement only that file. Stay inside its components, acceptance, and card excerpts.
B. Obey the invariants on llm-brief.md.
C. In each code repo you change, use a branch whose name contains the FEAT id. The pull request title must contain the FEAT id.
D. Verify with the file's testing section.
E. Update study-shield/docs/SCREEN_FLOWS_MOBILE.md and/or SCREEN_FLOWS_TV.md if the UI changed.
F. Do not move the markdown file to implemented/ or rejected/. Do not set review. Do not edit the SS-* pages (index story cards, experience, design, business-value, reliability, content, quality-and-speed, productionization, code-audit).
G. Optional: set status to In Progress on that one feature file, in its own docs commit. Skip this if you are not committing docs.
H. Open the pull request. Do not merge it unless the person who invoked you asks.
I. Stop. Do not start another id.

A merged pull request in the last 15 days, whose title or branch contains the FEAT id, is what moves the file later. You do not move it yourself.

If verify fails, stop and report what shipped and what is left. Do not mark the file Implemented.
```

## What "done" means

| Who | What they change |
|-----|------------------|
| Developer agent | Code, tests, screen-flow notes, and a pull request whose title contains the FEAT id. |
| Friday backlog job | After that pull request is merged, moves the file from `current/` to `implemented/` and sets `status: Implemented`. |
| A human | Sets `review: Reject` to take a file out of the queue. |

Do not delete a feature file. Shipped files stay in `implemented/`.
