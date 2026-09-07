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

## 2026-08-21 — Right-size freemium quizzes

**Decision:** Serve `QUIZZES_PER_CLASS = 2` quizzes per class (not the earlier
`QUIZZES_PER_SUBJECT = 5` sprawl), one per subject, first subjects win.

**Why:** Leaner catalog, faster first session, less content churn.
