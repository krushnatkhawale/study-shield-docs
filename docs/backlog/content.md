# Content

What appears on the TV. Kids stay if questions feel like play; parents stay
if questions feel like school.

---

### SS-CNT-01 — Short sessions; typed answers are not for young kids

| | |
|---|---|
| **Priority** | P0 |
| **Role** | Kid |
| **Apps** | `study-shield` TV, `study-shield-backend` |
| **Component** | Quiz composition / FITB |

**Story:** As a young child, I want a short game (about five questions) I
can finish with the remote, so I am not asked to type on the TV.

**Why:** FITB exists in the TV state map. For Nursery–Class 2 it is
overkill and breaks "thin and interesting". Long quizzes feel like tuition.

**Acceptance:**

- Default length: 5 questions for Nursery–UKG, 8 for Class 1–5, 10 max for
  6–10. Parent can request more later, not on first run.
- FITB is **not** sent for Nursery–Class 2. True/False and 4-choice only.
- Session time target: under ~3 minutes for KG including greeting and
  4-second celebration.
- Question text for KG is short enough to speak in one TTS breath.

**Not this:** Adaptive 30-question tests. On-screen keyboard as a skill
game.

---

### SS-CNT-02 — Reported questions reach a human the same day

| | |
|---|---|
| **Priority** | P1 |
| **Role** | Parent, Operator, Content author |
| **Apps** | `study-shield` mobile, `study-shield-backend`, `study-shield-backend-admin` |
| **Component** | Feedback module / admin inbox |

**Story:** As a parent who tapped 👎 or 🚩 because the answer was wrong, I
want that to actually get fixed, and as an operator I want a simple inbox
instead of reading database rows.

**Why:** Feedback APIs already exist. Without an admin loop, parents learn
that reporting is theatre. Wrong answers destroy school-trust (SS-BIZ-03).

**Acceptance:**

- Admin home: list of recent downvotes/reports with question text, grade,
  subject, count.
- Operator can hide a question from new bundles without a deploy.
- Parent does not need a ticket number; "Thanks — we will check" is enough.
- Duplicate reports on the same question collapse.

**Not this:** Public comment threads. Voting on the TV.

---

### SS-CNT-03 — Hindi subject uses Hindi script

| | |
|---|---|
| **Priority** | P1 |
| **Role** | Kid, Parent |
| **Apps** | `study-shield-backend`, `study-shield` TV, `study-shield` mobile |
| **Component** | Question bank |

**Story:** As a family using the Hindi subject, I want questions in Devanagari
(and spoken Hindi), not English sentences labelled "Hindi".

**Why:** The question-bank guide already flags this: GK was renamed Hindi
but still English text. Rural parents will notice immediately.

**Acceptance:**

- Hindi-subject items for Nursery–Class 5 are Devanagari; TTS locale `hi-IN`
  when auto-dictation is on.
- TV fonts render Hindi (and Marathi) without tofu boxes on the cheap stick
  we test.
- English subject stays English. Do not mix scripts in one question unless
  the item is explicitly "match the word".
- `QuestionBankContentTest` gains a script check for the Hindi subject.

**Not this:** Translating Math word problems in the same sprint unless
needed for KG.

---

### SS-CNT-04 — Local life in EVS examples

| | |
|---|---|
| **Priority** | P2 |
| **Role** | Kid |
| **Apps** | `study-shield-backend` |
| **Component** | Question bank |

**Story:** As a child in a town or village, I want EVS questions about
things I know (wells, markets, festivals, crops, buses) so the quiz feels
mine, not a city textbook photocopy.

**Acceptance:**

- Each EVS band includes a share of India-local, non-metro examples.
- Still age-right and non-political; authorship rules still apply
  (no placeholders, no duplicates).
- Pictures preferred for Nursery EVS (SS-DSN-02).

**Not this:** Region-specific forks per state in v1.

---

### SS-CNT-05 — Admin loads the bank without curl

| | |
|---|---|
| **Priority** | P2 |
| **Role** | Operator / content author |
| **Apps** | `study-shield-backend-admin`, `study-shield-backend` |
| **Component** | Admin console |

**Story:** As an operator, I want to load or refresh `question-bank.json`
and toggle catalog seeding from the Vaadin admin, so content ops do not
require curl and Render logs.

**Why:** Admin today is local H2 config (JWT, seeding flags) with default
`admin/admin123`. Real ops still live in the API. UX for families depends
on content actually being present.

**Acceptance:**

- Authenticated admin can trigger `questions/load` against the real backend
  (or upload the JSON) and see counts per class/subject.
- Catalog seeding flag is the same flag the backend already has — no second
  source of truth.
- Default passwords are not used in any shared environment.

**Not this:** Turning admin into a full CMS in the first pass. Letting the
TV pull the bank.
