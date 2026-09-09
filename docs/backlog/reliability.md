# Reliability — LLM implementation briefs

Copy **one** story into Buzz. Invariants: [llm-brief.md](llm-brief.md). Lost results and slow first bundle are UX bugs.

---

### SS-REL-01 — The result always lands on the right kid

| | |
|---|---|
| **Priority** | P0 |
| **Code status** | **Done in code** on TV ↔ mobile. **Partial** on backend identity. |
| **Work type** | **Do not rebuild** the socket path. Optional follow-up: key backend results by `childProfileId`. |
| **Repos** | Already done: `study-shield` mobile + tv. Follow-up: `study-shield-backend`. |

**Current behaviour (protect this)**

- `kidName` on `InterruptionCommand` and `QuizResultMessage` in **both** `Models.kt` and `tv/InterruptionCommand.kt`.
- `StudyViewModel.startSession` sets `kidName` from the selected kid.
- `StudyRepository` result listener: `childName = message.kidName ?: …`.
- `TvServerService.checkSavedLock()`: `savedCommand.copy(mobileIp = null, resultCallbackPort = null)`.
- Backend `POST /api/quiz-results` stores **`childName` string**; `quiz-attempts` uses `childProfileId`.

**Change to (follow-up only)**

If you pick this card, **do not** rewrite the LAN protocol. Optionally add `childId` to results **in addition to** `kidName` (still both protocol copies) and persist FK on `quiz_results`. Rename-safe attribution.

**Where to change (follow-up)**

| Path | Why |
|------|-----|
| `study-shield-backend/.../quizresult/entity/QuizResult.java` | childProfileId |
| Mobile `QuizResultRepository` | Send id |
| Both `InterruptionCommand` copies | If new fields |

**Do not:** Kid typing their name on TV. Removing `kidName` echo.

**Verify:** Switch kid, run two quizzes, each result on the correct card. Reboot TV mid-lock: no result sent to old callback (`checkSavedLock` tests if you add them — SS-QLT-01).

---

### SS-REL-02 — First quiz bundle in under two seconds

| | |
|---|---|
| **Priority** | P0 |
| **Code status** | **Partial — TD-1 still open** |
| **Work type** | **Enhance** `QuizBundleService` / seeder: **move work off the request path**. |
| **Repos** | **`study-shield-backend`** primary. Mobile only if you need a better waiting/error string. |

**Current behaviour**

- `QuizBundleService.createBundle` → `catalogSeeder.ensureCatalogForClass(...)` **inside the request transaction**.
- `QuizBundleSeeder` creates subjects/packs/quizzes/questions row-by-row (`QUIZZES_PER_CLASS = 2`, `QUESTIONS_PER_QUIZ = 10`).
- `app.catalog-seeding.enabled` default **false** (`application.yml`). `CatalogStartupSeeder` exists but is off.
- `TECH_DEBT.md` **TD-1**: first-hit can take minutes; Hikari leak warnings.
- Mobile `QuizLoader` / `PackCache`: waits on `POST /api/v1/quiz-bundles`.

**Change to**

`POST /api/v1/quiz-bundles` p95 &lt; 2s even for an unseen class. Seed at startup **or** async on miss; request path only reads.

**Where to change**

| Path | Why |
|------|-----|
| `ss-modulith/.../content/service/QuizBundleService.java` | Stop calling ensure in the request TX |
| `ss-modulith/.../content/service/QuizBundleSeeder.java` | Batch / pre-seed |
| `ss-modulith/.../content/seed/CatalogStartupSeeder.java` | Enable for known bands or document ops pre-load |
| `ss-modulith/src/main/resources/application.yml` | Flag |
| `TECH_DEBT.md` | Close TD-1 when done |
| `ss-regression-suite/.../content-freemium.feature` | Still asserts “bundle seeds catalog” — **update** the scenario |
| `mobile/.../data/QuizLoader.kt` | Timeout/error copy only |

**Implementation pointers**

- Do **not** move seeding onto the TV.
- Do **not** re-bundle the full bank into the APK (content ADR: on-demand load). Tiny Nursery fallback on mobile is a last resort.
- `POST /api/v1/questions/load` remains the ops/bulk path.

**Verify:** `./gradlew :ss-modulith:test`. Hit `quiz-bundles` twice for a fresh class against a remote-like DB; second and first both &lt; 2s after the fix. No Hikari leak logs.

---

### SS-REL-03 — Same Wi-Fi in one picture

| | |
|---|---|
| **Priority** | P1 |
| **Code status** | **Partial — enhance `NOT_ON_WIFI` copy** |
| **Work type** | **Enhance** existing Wi-Fi checks; add a simple illustration + reuse on discovery fail. |
| **Repos** | `study-shield` **mobile** (TV idle copy is SS-DSN-07). |

**Current behaviour**

- `StudyRepository.probeTtsLanguages`: fail fast `IllegalStateException("NOT_ON_WIFI")`.
- `StudyScreens.kt` maps that to a sentence about saving greeting language.
- `TvManagementScreen` / Library: empty discovery text “Searching…” / “Scan stopped”.
- `HistoryRepository.getCurrentSsid()` exists.

**Change to**

When not on Wi-Fi, or discovery empty: full-screen **phone + TV + one router**. Same component for pairing (SS-EXP-02) and TTS probe.

**Where to change**

| Path | Why |
|------|-----|
| New composable e.g. `mobile/.../ui/SameWifiHelp.kt` | Reuse |
| `StudyScreens.kt` ControlScreen / greeting probe UI | Call it |
| `TvManagementScreen.kt` | Empty state |

**Do not:** Dump AP isolation logs in the parent UI.

**Verify:** Phone on cellular, TV on Wi-Fi: picture, not a stack trace.

---

### SS-REL-04 — Offline is a sentence, not a spinner

| | |
|---|---|
| **Priority** | P1 |
| **Code status** | **Partial — enhance existing queues** |
| **Work type** | **Enhance** `ConnectivityObserver` + Room pending tables. Add a **Home banner**. Backend idempotency is a plus. |
| **Repos** | `study-shield` **mobile** (banner). Optional `study-shield-backend` for idempotent `POST /api/quiz-results`. |

**Current behaviour**

- OkHttp 7s timeouts (`RetrofitClient`).
- Queues: quiz results, kid profiles, `pending_feedback`; flush in `ConnectivityObserver`.
- Toasts: “Offline — changes will sync…”.
- Opening the app must **not** re-post synced results (`QuizResultRepository.insertFromBackend` / delete offline rows) — **keep this**.
- Backend result POST is **not** idempotent (duplicates if replayed).

**Change to**

Home banner: “Saved on this phone. Will send when internet is back.” LAN quiz still works via `PackCache`. Optional: client-generated result id unique on server.

**Where to change**

| Path | Why |
|------|-----|
| `mobile/.../ui/StudyScreens.kt` Home | Banner from SessionManager / pending DAOs |
| `mobile/.../data/QuizResultRepository.kt` | Keep no-repost invariant |
| `mobile/.../data/FeedbackRepository.kt` | Already upsert-friendly |
| `study-shield-backend/.../quizresult/` | Idempotency key if you touch backend |

**Do not:** Sync-conflict UI. Multi-device merge.

**Verify:** Airplane mode, finish TV quiz (LAN), see banner, restore network, one server row.

---

### SS-REL-05 — Reboot must not trap the kid on an old lock

| | |
|---|---|
| **Priority** | P2 |
| **Code status** | **Partial — enhance `LockPersistenceManager`** |
| **Work type** | **Enhance** existing boot replay. Add **expiry**. Keep callback strip. |
| **Repos** | `study-shield` **tv** (mobile unlock already exists). |

**Current behaviour**

- `LockPersistenceManager` saves serialized command; `BootReceiver` → `TvServerService.checkSavedLock()`.
- Replays any non-UNLOCK command with callback fields stripped.
- **No TTL** — BLOCK can return after a power cut hours later.

**Change to**

Restore BLOCK/TIMER only if still within original duration. STUDY/MCQ: idle unless phone is reachable; parent starts again. Phone `UNLOCK` always wins.

**Where to change**

| Path | Why |
|------|-----|
| `tv/.../LockPersistenceManager.kt` | Store saved-at timestamp |
| `tv/.../TvServerService.kt` `checkSavedLock` | Expiry policy |
| `tv/.../BootReceiver.kt` | Already starts service |

**Do not:** Cloud locks. TV calling backend.

**Verify:** Save BLOCK, reboot after duration elapsed → idle. UNLOCK from phone still works.
