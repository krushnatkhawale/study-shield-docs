# Reliability

Failures that look like "the app is not for people like me". Pairing, lost
results, and slow first load are UX bugs, not only ops bugs.

---

### SS-REL-01 — The result always lands on the right kid

| | |
|---|---|
| **Priority** | P0 |
| **Role** | Parent |
| **Apps** | `study-shield` mobile, `study-shield` TV, `study-shield-backend` |
| **Component** | `InterruptionCommand` / `QuizResultMessage` / results sync |

**Story:** As a parent, I want Rohan's score on Rohan's page every time,
including after I switch child or account, so I never think the quiz
"disappeared".

**Why:** Already failed once (stale `saved_command` / callback port). This is
the trust-breaker. Dual copies of the message types make it easy to regress.

**Acceptance:**

- Switching child mid-evening never writes the next result onto the previous
  child.
- TV reboot during a quiz does not send the old account's callback
  (existing `checkSavedLock` rule — keep tests around it).
- Parent sees "Rohan finished" within a few seconds of the TV celebration,
  or a plain "Waiting for TV…" then success.
- If the phone missed the callback: one "Get result" retry, then queue —
  never silent drop.
- Contract tests in SS-QLT-01 fail the build if `kidName` (and new fields)
  drift between modules.

**Not this:** Asking the kid to type their name on the TV.

---

### SS-REL-02 — First quiz bundle in under two seconds

| | |
|---|---|
| **Priority** | P0 |
| **Role** | Parent |
| **Apps** | `study-shield-backend`, `study-shield` mobile |
| **Component** | `POST /api/v1/quiz-bundles` / `QuizBundleSeeder` |

**Story:** As a parent who just tapped Start, I want the quiz to begin on the
TV almost immediately, so my child does not walk away while a spinner thinks.

**Why:** Backend tech debt TD-1: first bundle for a class can take minutes
while the catalog seeds on the request path. Rural latency to Render makes
it worse. Activation dies here.

**Acceptance:**

- `POST /api/v1/quiz-bundles` p95 < 2 s even for a class never seen in that
  environment (seed off the request path, or pre-seed Nursery–10).
- No Hikari "apparent leak" on first-hit.
- Mobile shows a determinate wait max a couple of seconds, then a plain
  error: "Could not load quiz. Try again." — not a timeout stack.
- Trial seed on login (`TrialContentDownloader`) must not block the UI.

**Not this:** Moving seeding onto the TV. Bundling the whole bank in the APK
again (contradicts the on-demand content ADR) unless as a tiny Nursery
offline fallback.

---

### SS-REL-03 — Same Wi-Fi in one picture

| | |
|---|---|
| **Priority** | P1 |
| **Role** | Parent |
| **Apps** | `study-shield` mobile, `study-shield` TV |
| **Component** | Pairing errors |

**Story:** As a parent whose phone is on mobile data and TV is on home Wi-Fi,
I want a picture that says "put both on the same Wi-Fi", so I can fix it
without a technician.

**Acceptance:**

- Detect "not on Wi-Fi" (already used for TTS probe) and show a full-screen
  illustration: phone + TV + one router.
- Detect "Wi-Fi but TV not found": same illustration plus "Type the code on
  the TV".
- Never mention AP isolation in the UI; put that in operator docs.
- Works when SSID names are in local script.

**Not this:** A network diagnostic log dump in the parent UI.

---

### SS-REL-04 — Offline is a sentence, not a spinner

| | |
|---|---|
| **Priority** | P1 |
| **Role** | Parent |
| **Apps** | `study-shield` mobile |
| **Component** | Offline queue (results, feedback, profiles) |

**Story:** As a parent with patchy data, I want to run a quiz on the LAN and
read "Saved on this phone. Will send when internet is back." so I am not
afraid I broke it.

**Why:** Offline queues already exist (results, feedback). The UX does not
explain them. 7-second timeouts help, but a spinner still feels like death.

**Acceptance:**

- Home shows a small, plain banner only when something is waiting to send.
- Start quiz on LAN works with no backend (cached packs for that child).
- Opening the app does **not** re-post old results (already specified in
  screen flows — keep a regression test).
- Feedback 👍👎🚩 still queues; parent is not blocked.

**Not this:** A sync-conflict UI. Multi-device merge for v1.

---

### SS-REL-05 — Reboot must not trap the kid on an old lock

| | |
|---|---|
| **Priority** | P2 |
| **Role** | Kid, Parent |
| **Apps** | `study-shield` TV, `study-shield` mobile |
| **Component** | `LockPersistenceManager` / BootReceiver |

**Story:** As a child, I want the TV to become a normal TV again after a
power cut, unless mum/dad starts a new quiz — so a stale lock never
kidnaps the living room.

**Acceptance:**

- BLOCK/TIMER restored after reboot only if still within the original
  duration; otherwise idle.
- STUDY/MCQ restored only if the phone is still reachable; else idle and
  parent sees "TV restarted — start again".
- Emergency unlock on the phone always wins.
- Stale callback fields are stripped (existing ADR).

**Not this:** Cloud-controlled TV locks. TV calling the backend to ask.
