# Quality and speed

How this agile team protects the parent/kid experience without slowing
delivery. These are stories — they get sprint slots — not wallpaper
principles.

---

### SS-QLT-01 — One schema for TV ↔ mobile commands

| | |
|---|---|
| **Priority** | P0 |
| **Role** | Engineering |
| **Apps** | `study-shield` mobile, `study-shield` TV |
| **Component** | `InterruptionCommand` / `QuizResultMessage` |

**Story:** As a developer changing a quiz field, I want a single contract
that both apps must satisfy, so we never again ship a TV that drops
`kidName` or a new greeting locale.

**Why:** Architecture rule: both apps keep their own copies. That is a
loaded footgun. Speed comes from *generating or testing* the contract, not
from more wiki text.

**Acceptance:**

- One canonical JSON schema (or codegen from one Kotlin module) for
  command + result + TTS cap-check.
- CI on `study-shield` fails if mobile and TV models diverge.
- Adding a field is one PR that updates both sides plus a golden fixture
  used in a round-trip unit test.
- Screen-flow docs mention the field only after the contract exists.

**Not this:** "Remember to update both" in a PR template with no test.

---

### SS-QLT-02 — Definition of Done includes a rural-parent pass

| | |
|---|---|
| **Priority** | P0 |
| **Role** | Whole team |
| **Apps** | Any user-facing change |
| **Component** | Team working agreement |

**Story:** As a team, we want a story to be Done only when a person who is
not us can start or understand the quiz without coaching, so we stop
shipping developer-complete work.

**Acceptance:**

Definition of Ready:

- Role, app(s), and "not this" (especially TV thinness) are filled.
- First-quiz path impact is stated (helps / no change / risks).
- Copy is drafted in Hindi or Marathi *or* explicitly English-only with
  reason.

Definition of Done:

- [ ] Demoed on a phone, not only an emulator, for mobile stories.
- [ ] Demoed on the living-room TV / stick for TV stories.
- [ ] No banned jargon in parent-visible strings (SS-EXP-05).
- [ ] TV gained no menu, account, or HTTP client.
- [ ] Result still attributed to the correct kid (SS-REL-01 smoke).
- [ ] 5-minute hallway test: one non-author follows the happy path from
  the UI alone. If they stall, it is not Done.

Sprint ritual: that hallway test is the demo, on the cheap device pair.

**Not this:** A 12-page process. QA as a separate phase after "dev done".

---

### SS-QLT-03 — Cheap phone + cheap TV in CI and in the room

| | |
|---|---|
| **Priority** | P1 |
| **Role** | Engineering / QA |
| **Apps** | `study-shield` mobile, TV |
| **Component** | Device lab |

**Story:** As a tester, I want the default proof device to be a low-RAM
Android phone and a cheap Android TV stick on a domestic router, so
flagship-only bugs do not escape.

**Acceptance:**

- Named devices in the team room (or a cloud farm job): one Android 8–10
  phone, one Android TV stick.
- PR checks: at least unit/Robolectric + assembleDebug for `:mobile` and
  `:tv`; backend `:ss-modulith:test` + regression features that cover
  bundle + feedback.
- Once per sprint: physical pairing test (SS-EXP-02) recorded as a
  checklist, not a screenshot of the emulator.
- Backend first-bundle timing (SS-REL-02) measured against a remote DB,
  not only H2.

**Not this:** Waiting for a perfect device farm before manual cheap-device
testing.

---

### SS-QLT-04 — Thin-TV checklist on every TV PR

| | |
|---|---|
| **Priority** | P1 |
| **Role** | Engineering |
| **Apps** | `study-shield` TV |
| **Component** | Pull request template |

**Story:** As a reviewer, I want a short TV checklist so "just one more
screen" cannot land.

**Acceptance:**

TV PR template:

- [ ] No new Activity/menu the kid can open
- [ ] No HTTP/Retrofit on TV
- [ ] Remote: D-pad + OK only for the new UI
- [ ] Session still ends without a kid-operated Exit
- [ ] APK size delta noted
- [ ] Command/result schema updated both sides (SS-QLT-01)
- [ ] Greeting/TTS fallback still English if locale missing

A reviewer may reject a TV PR that is "complete" but thick.

**Not this:** The same checklist on backend-only PRs.

---

### SS-QLT-05 — Privacy-safe activation telemetry

| | |
|---|---|
| **Priority** | P2 |
| **Role** | Product |
| **Apps** | `study-shield` mobile, `study-shield-backend` |
| **Component** | Analytics |

**Story:** As the team, we want counts of the first-quiz funnel without
storing extra child data, so we can see rural activation fail without
reading people's names.

**Acceptance:**

- Events: app_open, child_saved, tv_paired, quiz_started, result_received,
  share_tapped — counters only, with app version and language.
- No question text, no raw scores tied to a name in analytics. Kid names
  stay in the product DB under existing auth.
- DPDP-minded: document what is collected in one parent-language paragraph
  in Settings.
- Funnel shown in sprint review (SS-BIZ-01).

**Not this:** Third-party ad SDKs. Session replay of the living room.

---

### SS-QLT-06 — Weekly TV demo and small slices

| | |
|---|---|
| **Priority** | P2 |
| **Role** | Whole team |
| **Apps** | All |
| **Component** | Agile cadence |

**Story:** As a team, we want a weekly demo that is always a child on a
real TV plus a parent on a real phone, so unfinished "platform work"
cannot hide.

**Acceptance:**

- Cadence: weekly increment, stories sliced to one visible outcome
  (this backlog's story grain).
- Stand-up names blockers in pairing, bundle latency, and copy — not
  only tickets.
- Backend, mobile, and TV changes for one outcome travel together (or
  feature-flagged) so main is always demoable.
- Docs site (this repo) updates in the same slice when IA or flows
  change.
- Retro every 2 weeks asks: "Would a parent in Satara finish this
  without us?"

**Not this:** Two-month "UX redesign" branches. Separate mobile and TV
sprints that meet at the end.

---

## Working habits (do not ticket separately — just do them)

| Habit | Why it is here |
|-------|----------------|
| **Trunk-based, small PRs** | Dual-app protocol rot happens on long branches. |
| **Feature flags on mobile, not TV** | TV stays a renderer of the last command. |
| **Contract tests > UI tests for sockets** | LAN flake is real; JSON shape is not. |
| **Keep `QuestionBankContentTest` green** | Content quality is a unit-test problem. |
| **Regression suite** (`ss-regression-suite`) | Protect bundle, auth, feedback; update when seeding flags change. |
| **One writer for parent copy** | Mixed English/Hindi by five developers will read as broken. |
| **No new TV capability without a mobile control** | Parent initiates; kid plays. |
| **Hallway test in Hindi** | English-only Done is a lie for this product. |
| **Build TV and mobile in the same CI pipeline** | A green mobile with a red TV is not green. |
| **Pages site builds on every docs change** | This backlog is useless if the team cannot open it. |
