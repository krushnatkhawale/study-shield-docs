# Quality and speed — LLM implementation briefs

Copy **one** story into Buzz. Practice cards are working agreements, not app features.

---

### SS-QLT-01 — One schema for TV ↔ mobile commands

| | |
|---|---|
| **Priority** | P0 |
| **Code status** | **Not in code** |
| **Work type** | **New** contract test (or shared module). **Enhance** the duplicated types — do not invent a third JSON dialect. |
| **Repos** | `study-shield` **mobile + tv** (same Gradle project). |

**Current behaviour**

- `InterruptionCommand` / `QuizResultMessage` / `TtsCapabilitiesMessage` duplicated:
  - `mobile/src/main/java/com/kaushalya/interrupter/data/Models.kt`
  - `tv/src/main/java/com/kaushalya/interrupter/InterruptionCommand.kt`
- TV `QuizQuestion` has **no** `id`; mobile’s does.
- Tests: no round-trip. Docs say “update both”.

**Change to**

CI fails if the two models diverge. Adding a field is one PR: both copies + golden JSON fixture.

**Where to change**

| Path | Why |
|------|-----|
| Preferred: `study-shield` shared JVM module used by mobile + tv | Single source |
| Or: `mobile/src/test` + `tv/src/test` that parse the **same** `fixtures/command.json` | Fastest |
| `TvServerService` / `StudyRepository` | Serialize with kotlinx.serialization as today |

**Implementation pointers**

- Existing pattern: kotlinx `@Serializable` on both. Fixture should include `kidName`, `revealReadLock`, `autoDictation`, `fastAnswerThresholdMs`, `greetingLanguage`, `avatarId`, `mobileIp`, `resultCallbackPort`.
- `TTS_CAP_CHECK` must never be persisted as a lock.

**Do not:** “Remember to update both” as the only control.

**Verify:** `./gradlew :mobile:test :tv:test` (or shared module test). Change one field, confirm the test fails until both match.

---

### SS-QLT-02 — Definition of Done includes a rural-parent pass

| | |
|---|---|
| **Priority** | P0 |
| **Code status** | **Practice** |
| **Work type** | Team agreement. Optional: add a short checklist file in `study-shield/.github/` or this docs repo. |
| **Repos** | Process; optional `study-shield` PR template (also SS-QLT-04). |

**Change to:** Ready/Done as on the original card (hallway test, no TV HTTP, jargon ban, cheap device demo).

**Do not:** A 12-page process. QA-only “dev done”.

---

### SS-QLT-03 — Cheap phone + cheap TV in CI and in the room

| | |
|---|---|
| **Priority** | P1 |
| **Code status** | **Practice** |
| **Work type** | Process + optional CI jobs on `study-shield` / `study-shield-backend`. |
| **Repos** | All product repos’ CI; not a user-facing feature. |

**Current behaviour:** Local Gradle. Docs GitHub Actions for this **docs** site only.

**Change to:** Named cheap devices; per-sprint physical pairing; `quiz-bundles` timing vs remote DB (SS-REL-02).

**Verify:** Sprint note names the device pair.

---

### SS-QLT-04 — Thin-TV checklist on every TV PR

| | |
|---|---|
| **Priority** | P1 |
| **Code status** | **Not in code** |
| **Work type** | **New** file in the Android repo. |
| **Repos** | **`study-shield`** `.github/pull_request_template.md` (or `PULL_REQUEST_TEMPLATE.md`). |

**Change to:** Checklist: no kid menu, no HTTP on TV, D-pad+OK, no kid Exit, APK size delta, both protocol copies, TTS English fallback.

**Where to change:** `/Users/hulk/.buzz/REPOS/study-shield/.github/pull_request_template.md`

**Do not:** Same checklist on backend-only PRs (use a TV-path note: “skip if mobile-only”).

**Verify:** Open a dummy PR description locally.

---

### SS-QLT-05 — Privacy-safe activation telemetry

| | |
|---|---|
| **Priority** | P2 |
| **Code status** | **Not in code** |
| **Work type** | **New**. Implement SS-BIZ-01 events without extra child PII. |
| **Repos** | `study-shield` mobile; optional `study-shield-backend` ingest. |

**Change to:** Counters only. One parent-language paragraph in Settings. DPDP-minded.

**Do not:** Ad SDKs. Question text in events.

**Verify:** Logcat/event dump has no kid name.

---

### SS-QLT-06 — Weekly TV demo and small slices

| | |
|---|---|
| **Priority** | P2 |
| **Code status** | **Practice** |
| **Work type** | Cadence. When a story spans mobile + TV + backend, **one PR stack or flag** so `main` stays demoable. |

**Change to:** Weekly demo is always a real TV + real phone. Retro: “Would a parent in Satara finish this without us?”

**Do not:** Two-month UX branches. Separate mobile/TV sprints that meet at the end.

---

## Working habits (do not ticket separately)

| Habit | Why |
|-------|-----|
| Small PRs / trunk | Dual-app protocol rot on long branches |
| Feature flags on **mobile**, not TV | TV renders the last command |
| Contract tests > flaky LAN UI tests | SS-QLT-01 |
| Keep `QuestionBankContentTest` green | Content quality |
| Update `ss-regression-suite` when seeding flags change | SS-REL-02 |
| One writer for parent copy | SS-EXP-05 / SS-EXP-03 |
| No new TV capability without a mobile control | Architecture |
| Build `:mobile` and `:tv` in the same CI | A green mobile + red TV is not green |
