# Content — LLM implementation briefs

Copy **one** story into Buzz. Bank rules: [question-bank guide](../decisions/question-bank-guide.md). Tests: `QuestionBankContentTest`.

---

### SS-CNT-01 — Short sessions; typed answers are not for young kids

| | |
|---|---|
| **Priority** | P0 |
| **Code status** | **Partial — enhance length + hide FITB for young grades** |
| **Work type** | **Enhance** `QUESTIONS_PER_QUIZ` / bundle composition. **Enhance** mobile Library so FITB is not a default kid path. |
| **Repos** | `study-shield-backend` (length); `study-shield` mobile (Library modes) + tv (`FitbUI` may remain for manual/dev). |

**Current behaviour**

- `QuizBundleSeeder.QUESTIONS_PER_QUIZ = 10` for **all** classes.
- Curated bank: MCQ or True/False only (`QuestionBankContentTest` forbids FITB).
- Mobile Library mode list includes **Fill In The Blank** → TV `FitbUI` letter grid.
- `QuizLoader` drops questions with empty options (API FITB would not show in packs).

**Change to**

Default length: **5** Nursery–UKG, **8** class 1–5, **10** max class 6–10. Do not send FITB for Nursery–class 2. Library should not offer FITB as a parent-facing kid quiz (keep MCQ / study session).

**Where to change**

| Path | Why |
|------|-----|
| `ss-modulith/.../QuizBundleSeeder.java` | Per-band question count |
| `ss-modulith/.../QuizBundleService.java` | Slice quizzes when issuing |
| `QuestionBankContentTest` | Don’t require 10 on screen if you still author ≥10 in the bank (keep authorship volume; **serve** fewer) |
| `mobile/.../ui/StudyScreens.kt` `ControlScreen` `modes` | Hide FITB from parent kid path |
| `tv/.../MainActivity.kt` `FitbUI` | Leave for compat; don’t use in `startSession` packs |

**Implementation pointers**

- Serving 5 of 10 authored questions is better than shrinking the bank below test minimums — or split tests: authored ≥10, delivered 5.
- `StudyViewModel.startSession` uses pack questions from `QuizLoader` — trim there **or** in seeder, not on TV.

**Do not:** On-screen keyboard as a “skill game” for KG.

**Verify:** `:ss-modulith:test`. Nursery pack on TV has ~5 MCQ/TF, no FITB.

---

### SS-CNT-02 — Reported questions reach a human the same day

| | |
|---|---|
| **Priority** | P1 |
| **Code status** | **Partial — enhance admin; API already exists** |
| **Work type** | **Enhance** Vaadin admin with a **feedback inbox**. Reuse blacklist. Do not rebuild mobile 👍👎🚩. |
| **Repos** | **`study-shield-backend-admin`** primary; maybe list endpoint on **`study-shield-backend`**. Mobile already posts feedback. |

**Current behaviour**

- Mobile `QuizReviewScreen` → `FeedbackRepository` → `PUT /api/v1/questions/{id}/feedback`.
- Backend `QuestionFeedbackController` upsert per `(account_id, question_id)`.
- Admin `QuestionEditorDialog` has **Blacklisted**; bundles skip `blacklisted` questions.
- **No** admin view of feedback. `SettingsView` collection list omits `question-feedback`.

**Change to**

Admin home/inbox: recent downvotes/reports, question text, grade, subject, count. Operator can blacklist without a deploy. Parent still just sees “Thanks”.

**Where to change**

| Path | Why |
|------|-----|
| `study-shield-backend/.../feedback/` | Add `GET` list-all for ADMIN if missing |
| `study-shield-backend-admin/.../ui/` new `FeedbackInboxView` | Grid + blacklist action |
| `MainLayout.java` | Nav link |
| `BackendDataService.java` | Client for the new list |

**Do not:** Public comments. Voting on TV. Auto-delete questions on one downvote without a human.

**Verify:** Downvote from mobile; row appears in admin; blacklist; new bundle omits it.

---

### SS-CNT-03 — Hindi subject uses Hindi script

| | |
|---|---|
| **Priority** | P1 |
| **Code status** | **Not in code** (documented as D3 / later) |
| **Work type** | **New** bank content + TTS already supports `hi-IN`. |
| **Repos** | **`study-shield-backend`** bank; **`study-shield` tv** font check; mobile review display. |

**Current behaviour**

- `QuestionBankContent` header: Hindi = English text, India topics. Nursery Hindi is traffic lights / peacock in English.
- Loader sets quiz language `"English"`.
- TV greeting can already speak `hi-IN` (`CompletionMessages`, `configureKidTts`).

**Change to**

Hindi-subject items Nursery–class 5 in Devanagari. Auto-dictation uses `hi-IN` for that subject (or kid greeting language — pick one rule and document it). No tofu boxes on the cheap TV stick.

**Where to change**

| Path | Why |
|------|-----|
| `ss-modulith/.../content/seed/QuestionBankContent.java` | Replace Hindi lists |
| `QuestionBankContentTest` | Optional script assertion |
| `question-bank.json` | Regenerate from bank |
| `QuestionBankLoader` | Don’t force English on Hindi subject |
| TV quiz `Text` | Confirm Noto/system Hindi |
| `TrialContentDownloader.kt` | Trial Hindi items if seeded from mobile |

**Do not:** Translating Math word problems in the same PR unless required.

**Verify:** `:ss-modulith:test`. TV shows Devanagari; TTS speaks Hindi when dictation on.

---

### SS-CNT-04 — Local life in EVS examples

| | |
|---|---|
| **Priority** | P2 |
| **Code status** | **Partial — enhance EVS strings in the bank** |
| **Work type** | **Enhance** `QuestionBankContent` EVS lists. No app UI. |
| **Repos** | **`study-shield-backend`** only (regenerate `question-bank.json`). |

**Current behaviour**

EVS is generic science; stronger India items live under **Hindi** (Diwali, ₹, police 100).

**Change to**

Each EVS band includes village/town life (market, bus, well, festivals) still age-right. Authorship rules still apply (volume, no placeholders, no dupes).

**Where to change:** `QuestionBankContent.java` EVS maps; `QuestionBankContentTest`; regenerate JSON.

**Do not:** Per-state forks in v1.

**Verify:** `:ss-modulith:test`. Spot-check Nursery EVS.

---

### SS-CNT-05 — Admin loads the bank without curl

| | |
|---|---|
| **Priority** | P2 |
| **Code status** | **Partial — enhance admin; load API exists** |
| **Work type** | **Enhance** Vaadin: button that calls existing `POST /api/v1/questions/load`. |
| **Repos** | **`study-shield-backend-admin`**. Backend endpoint already implemented. |

**Current behaviour**

- Load: `POST /api/v1/questions/load` (curl `question-bank.json`).
- Admin: question CRUD, JSON table browser. `BackendDataService` has no `questions/load`.
- `ApplicationSettings.catalogSeedingEnabled` in admin H2 is **not** the backend flag.
- README `admin/admin123` is **stale** — login is `POST /api/auth/admin-signin`.

**Change to**

Authenticated admin uploads/triggers load and sees counts per class/subject. Seeding toggle must write the **backend** config or be removed from admin H2 so there is one source of truth.

**Where to change**

| Path | Why |
|------|-----|
| `admin/.../BackendDataService.java` | `post("/api/v1/questions/load", body)` |
| New view or `DashboardView` | File upload / “Load bank” |
| `MainLayout.java` | Link |
| `study-shield-backend-admin/README.md` | Fix credentials |

**Do not:** Full CMS rewrite. TV pulling the bank.

**Verify:** Admin login against backend; load JSON; dashboard question count rises.
