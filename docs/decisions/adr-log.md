# Decision Log (ADRs)

Chronological record of the significant decisions made across the StudyShield /
Open-School family. Each entry is intentionally short; deeper detail lives in the
linked docs.

## 2026-09-04 — Content architecture overhaul

**Decision:** Backend starts with an **empty DB** and loads the question bank **on demand**
via a new `POST /api/v1/questions/load` batch endpoint. The mobile app seeds the Trial/Nursery
bank on login; no quiz assets are bundled in the APK. `Exp` grade renamed to `Trial`; the
question bank is restructured to 4 subjects (**Math, English, EVS, Hindi**) across
**Nursery / Junior KG (LKG) / Sr KG (UKG) / Class 1–10**.

**Why:** Content should evolve (add subjects/grades, fix errors) without an app release and
without shipping a large static bundle; a single on-demand loader keeps one source of truth.

**Details:** [Question bank process & rules](question-bank-guide.md) ·
[Architecture: backend](../architecture/backend.md).

---

## 2026-09-04 — Question-bank documentation

**Decision:** Author and preserve the question-bank generation process as a reusable guide
(now mirrored into this docs site) so future subjects/grades follow the same rules and pass
`QuestionBankContentTest`.

**Details:** [Question bank process & rules](question-bank-guide.md).

---

## 2026-09-03 — Result lost after account switch — fixed

**Decision:** Add `kidName` to both mobile and TV copies of `InterruptionCommand` and
`QuizResultMessage`; strip stale `mobileIp`/`resultCallbackPort` fields when the TV replays
a stored command, so results are attributed to the correct kid across account switches.

**Why:** The TV was replaying a stale `saved_command` carrying an old account's callback
port, dropping the result for the new account.

---

## 2026-09-03 — Kotlin/Native quiz countermeasures (features 4/5/6)

**Decision:** Add a configurable per-kid quiz threshold, a read-lock, and kid-insight charts;
plus a kids-list → kid-detail UX revamp.

---

## 2026-09-05 — Auth persistence and 401 error resolution

**Decision:**
1.  **Mobile**: Use `rememberSaveable` for navigation state and improve `isCheckingSession` logic.
2.  **Backend**: Allow `/api/auth/validate` to bypass the JWT filter and return `200 OK` with `valid: false` on failure instead of `401 Unauthorized`.
3.  **Mobile**: Update `AuthExpiryInterceptor` to ignore `401` on the validation endpoint and `AuthViewModel` to trust local session on validation failure for offline resilience.

**Why:** The app was reverting to the Welcome screen due to lost state, a race condition, and the backend's `401` response on validation triggering the mobile interceptor to clear the session.

**Decision:** Serve `QUIZZES_PER_CLASS = 2` quizzes per class (not the earlier
`QUIZZES_PER_SUBJECT = 5` sprawl), one per subject, first subjects win.

**Why:** Leaner catalog, faster first session, less content churn.

**Superseded 2026-09-12:** Freemium now issues **one quiz per subject that has
questions** (Class 3 gets Math, EVS, English, Hindi — not Math+EVS only). Rebuild
via `POST /api/v1/quiz-bundles/rebuild-catalog` (deletes issued bundles).

---

## 2026-09-12 — Vaadin admin as the curriculum console

**Decision:** Keep **Vaadin 24** for `study-shield-backend-admin`. Replace the JSON
table browser as the primary UX with catalog screens: Boards, Classes, Subjects,
Packs (FREEMIUM / PREMIUM / LIBRARY / PROMOTIONAL / SEASONAL / COMPLEMENTARY),
Quizzes, and a Question bank. Question edits still version; **remove from quiz**
moves the question to a subject Library pack instead of deleting it. Light/dark
Lumo theme `studyshield`.

**Why:** The previous admin could hit the APIs but was not an operator product
(no board CRUD, pack types, or add-from-bank). Backend already had REST for
boards/classes/subjects/quizzes/questions; packs gained `packType` + validity
dates; questions gained `subjectIds` and `POST /questions/{id}/assign-quiz`.

---

## 2026-09-13 — Per-environment schemas (ss-dev / ss-prod) + admin environment switcher

**Decision:** One Postgres database, two schemas — `"ss-dev"` (development, default
profile) and `"ss-prod"` (production, `prod` profile). `schema.sql` creates and
backfills **both** on every boot so they stay in lock-step; the `prod` profile only
overrides `hibernate.default_schema`. When prod moves to its own database later, only
`DATABASE_URL` in the `prod` profile changes.

**Also:** the Vaadin admin console gains an **Environment** dropdown (`dev` / `prod`)
in the header. It flips the backend base URL the console talks to
(`studyshield.backend.base-url` vs `studyshield.backend.prod-base-url`), so all CRUD
hits the selected environment's schema — the schema follows the backend's runtime
profile. Switching an environment re-authenticates against the new backend.

**Why:** Separate dev vs prod data without a second database or a second admin deploy;
the same console can manage both environments and cross-check them side by side.

**Details:** [Per-repo: backend](../per-repo/backend.md) ·
[Per-repo: admin](../per-repo/admin.md).
