# Experience — LLM implementation briefs

Copy **one** story (from its heading through **Verify**) into Buzz. Read [how to feed a story](llm-brief.md) first.

Local roots: `/Users/hulk/.buzz/REPOS/study-shield` (modules `mobile/`, `tv/`), `study-shield-backend`, `study-shield-backend-admin`.

**Invariants:** TV has no HTTP. Protocol types are duplicated in `mobile/.../data/Models.kt` and `tv/.../InterruptionCommand.kt` — change both. Parent initiates; kid only plays.

---

### SS-EXP-01 — Three steps to first quiz

| | |
|---|---|
| **Priority** | P0 |
| **Code status** | **Done in code (IMPLEMENTED)** |
| **Work type** | **New** first-run shell on mobile. Reuse existing Kid form, TV discovery, and Select Content — do not rewrite those from scratch. |
| **Repos** | `study-shield` **mobile only** (optional copy tweaks on TV are SS-DSN-07 / SS-EXP-05). |
| **Depends on** | Pairing UX SS-EXP-02; hide ProfData SS-DSN-03; copy SS-EXP-05. Can ship a Home stepper that *calls* existing screens before those land. |

**Implemented (2026-09-09):** Added `FirstRunStepper` (1 Add child → 2 Find TV → 3 Start quiz) as the Home destination until the first quiz starts; new `SessionManager.hasCompletedFirstQuiz` flag gates the switched Home (`StudyScreens.kt`, `SessionManager.kt`). The stepper reuses the existing kid form (`KidFormScreen`), NSD discovery (`StudyViewModel.startDiscovery` / `selectedTvIp`), and `ContentSelectionScreen`; manual-IP entry is moved behind "Need help?". ProfData removed from first-run drawer. Returning users with a kid + remembered TV get a "Start quiz" CTA card on Home. Verified `:mobile:assembleDebug`; `docs/SCREEN_FLOWS_MOBILE.md` updated.

**Current behaviour**

- `mobile/.../MainActivity.kt`: splash → session validate → **FeatureCarouselScreen** (first run) → Welcome (Create Account / Sign In / Guest) → `MainScreen`.
- `mobile/.../ui/StudyScreens.kt` `MainScreen`: `ModalNavigationDrawer` with Home, Library, Connected TVs, Kids, Results, Settings, **ProfData** (Quiz Setup / Parents if not guest).
- First quiz is **Library** `ControlScreen`: button `START STUDY NOW` → `ContentSelectionScreen`.
- `KidProfileRepository.ensureDefaultKid()` creates **Kid 1 / Trial**, so many parents never “add a child”.

**Change to**

A numbered **1 Child → 2 TV → 3 Start** path as the first surface after auth (guest included). Returning users who already have a kid + remembered TV see one primary **Start quiz** on Home. Advanced screens move behind More / drawer after first success.

**Where to change**

| Path under `study-shield/` | Why |
|----------------------------|-----|
| `mobile/.../ui/StudyScreens.kt` | Home composable, drawer `items`, navigation to content/kids/TV |
| `mobile/.../MainActivity.kt` | Post-auth destination; whether carousel still blocks |
| `mobile/.../ui/auth/FeatureCarouselScreen.kt` | Shorten or skip once stepper exists |
| `mobile/.../data/KidProfileRepository.kt` | Keep default kid, but stepper should *offer rename* not hide the child step |
| `mobile/.../data/SessionManager.kt` | Flag `hasCompletedFirstQuiz` / `hasSeenStepper` |
| `docs/SCREEN_FLOWS_MOBILE.md` | Update flow map |

**Implementation pointers**

- Do **not** put catalog, PIN, syllabus, or parent-add on this path (SS-EXP-06 / SS-EXP-09 later).
- Step 2 should navigate to existing discovery (`TvManagementScreen` or a slim wrapper around `StudyRepository.startDiscovery()`), not a new socket stack.
- Step 3 should call the same path as `START STUDY NOW` → `ContentSelectionScreen` / `StudyViewModel.startSession`.
- Guest must complete the path (`sessionManager.isGuest` already hides some drawer items).

**Acceptance**

- After auth, Home shows 1 / 2 / 3 or a single Start quiz if kid + TV already known.
- ProfData is not on the first-run drawer (SS-DSN-03).
- Copy: Add child, Find TV, Start quiz — never Activate Interrupter.

**Do not:** Longer carousel. TV-side wizard. Backend changes.

**Verify:** `:mobile:assembleDebug`. Guest + signed-in: cold install to session start on emulator. Update `SCREEN_FLOWS_MOBILE.md`.

---

### SS-EXP-02 — Pair the TV without typing an IP

| | |
|---|---|
| **Priority** | P0 |
| **Code status** | **Done in code (IMPLEMENTED)** |
| **Work type** | **Enhance** NSD discovery + Remember-TV. Stop using the IP field as the primary UI. Add a human pairing code on TV idle. |
| **Repos** | `study-shield` **mobile + tv** (same Android repo, two modules). |

**Implemented (2026-09-10):**

- TV: `PairCodeStore` generates and persists a 4-digit code (`tv_server_prefs`); `TvServerService` advertises it in the NSD TXT record (`setAttribute("PAIR_CODE", …)`) and answers a non-persisted `PAIR_CODE_CHECK` probe (`PairCodeMessage`) — the `TTS_CAP_CHECK` pattern.
- TV idle (`MainActivity`): code shown huge in a rounded box under “Ready to play!”; “On your phone, tap this TV or enter the code above”; IP demoted to a small faded footer.
- Mobile: `StudyRepository.pairCodeOf(NsdServiceInfo)` reads the advertised code (defensive length-byte strip); `verifyPairCode(ip, code)` probes over TCP. `PairCodeMessage` added to **both** `Models.kt` and `InterruptionCommand.kt`.
- `StudyViewModel.connectByPairCode(code)`: matches advertised codes first, then TCP-verify, sets `selectedTvIp`/`manualIp`; `ControlScreen` (Library) is now name-list-primary with code shown, numeric code entry, and manual IP hidden behind “Need help?”.
- `TvManagementScreen`: code shown on discovered rows + “Or enter the TV's 4-digit pairing code” section (remembers on match); SSID grouping kept. First-run “Step 2 Find TV” gains the same code entry and per-row codes.
- Verified `:tv:assembleDebug` `:mobile:assembleDebug` (corretto 21).

**Current behaviour**

- TV `TvServerService` registers NSD `_interrupter._tcp` on port **8888**, name `Interrupter-{deviceName}`.
- Mobile `StudyRepository` discovers `NsdServiceInfo`; `ControlScreen` (Library) still has **OutlinedTextField “TV IP Address”** as the hero; list of discovered TVs is secondary.
- `TvManagementScreen`: Scan Now, Remember per Wi-Fi SSID (`HistoryRepository`).
- TV idle (`MainActivity` `type == null`): device name, **“Interrupter Ready! 🚀”**, **“Connect using IP: $ip”**.
- Session start uses `selectedTvIp` / `manualIp` in `StudyViewModel.startSession` → TCP to that host:8888.

**Change to**

Parent taps a **TV name** (or types a **4-digit code** shown huge on the TV). IP may stay in a footer / debug, never as the main field. Discovery remains LAN-only.

**Where to change**

| Path | Why |
|------|-----|
| `tv/.../MainActivity.kt` idle branch | Show room code + “Ready to play”; IP small |
| `tv/.../TvServerService.kt` | Generate/persist 4-digit code; include in NSD txt records **or** accept a `PAIR_CODE` check command |
| `mobile/.../ui/StudyScreens.kt` `ControlScreen` | Remove IP as primary; name list + numeric fallback |
| `mobile/.../ui/TvManagementScreen.kt` | Same pairing UX |
| `mobile/.../data/StudyRepository.kt` | Discovery already exists — extend, don’t replace |
| `mobile/.../data/Models.kt` + `tv/.../InterruptionCommand.kt` | If you add `PAIR_CODE` / advertise fields, **both copies** |
| `docs/SCREEN_FLOWS_TV.md`, `SCREEN_FLOWS_MOBILE.md` | Idle + pairing |

**Implementation pointers**

- **Enhance** `startDiscovery()` / `_discoveredTvs`. Do not add HTTP on TV.
- Prefer NSD `setAttribute` for the code so mobile can match without a new command; if you add a command, never persist it as a lock (`TTS_CAP_CHECK` pattern in `TvServerService`).
- Remembered TVs: keep SSID grouping in `TvManagementScreen`.
- Failure copy: same Wi-Fi (SS-REL-03). No “callback port”.

**Acceptance**

- Happy path: no typing of `192.168.x.x`.
- Fallback: numeric keypad for the 4-digit code.
- `lastTvIp` still stored for `probeTtsLanguages` (greeting check) — implementation detail, not shown as the hero.

**Do not:** TV calling the internet. Port settings screen.

**Verify:** `:tv:assembleDebug` `:mobile:assembleDebug`. Two devices or emulator + TV: discover by name, start a quiz. Manual IP still works if hidden behind “Need help?”.

---

### SS-EXP-03 — App speaks the parent's language

| | |
|---|---|
| **Priority** | P0 |
| **Code status** | **Done in code (IMPLEMENTED)** |
| **Work type** | **New** Android resource locales + first-run picker. **Do not confuse** with existing `KidQuizConfig.greetingLanguage`. |
| **Repos** | `study-shield` **mobile** (TV already maps greeting locale via TTS). |

**Current behaviour**

- No `mobile/src/main/res/values-hi/` or `values-mr/`. Strings are mostly hardcoded English in Compose.
- `GreetingLanguages` in `Models.kt`: `en`, `mr-IN`, `hi-IN` for **TV post-quiz** message + TTS only (`QuizPresentationConfigCard`).
- TV `configureKidTts` / `CompletionMessages` already speak that locale.

**Change to**

Parent picks हिंदी / मराठी / English once; **all parent screens on the first-quiz path** use that locale (Home, add child, find TV, start, results). TV kid greeting stays the per-kid picker.

**Where to change**

| Path | Why |
|------|-----|
| `mobile/src/main/res/values/strings.xml` + `values-hi/` + `values-mr/` | Extract hardcoded `Text("…")` on the first-quiz path |
| `mobile/.../ui/StudyScreens.kt`, auth screens, Kid form, Results | Use `stringResource` |
| `mobile/.../data/SessionManager.kt` | Persist `appLocale` |
| `mobile/.../MainActivity.kt` | Apply `AppCompatDelegate.setApplicationLocales` before setContent |
| First-run UI (new small screen or Welcome) | Language choice **before** the stepper |

**Implementation pointers**

- Keep `greetingLanguage` on `KidQuizConfig` / `InterruptionCommand` as-is (TV). App locale is a **different** setting.
- Digits and scores stay `8 / 10`.
- If a string is missing, English fallback — never block setup.

**Do not:** Language settings UI on the TV. Machine-translating debug/ProfData.

**Verify:** Switch locale, walk add-child → find TV → results. Greeting on TV still follows kid config.

---

### SS-EXP-04 — Performance in plain words, not charts-first

| | |
|---|---|
| **Priority** | P0 |
| **Code status** | **Done in code (IMPLEMENTED)** |
| **Work type** | **Enhance** existing Feature 6 charts: lead with a sentence; keep charts under “See more”. |
| **Repos** | `study-shield` **mobile**. |

**Current behaviour**

- `KidProfileScreen`: latest % + “N fast” on the card (`QuizResultDao.getResultsByChild`).
- `KidDetailScreen`: **charts first** — bar of %, donut Great/Good/Needs practice, fast-answer insight. Empty: “No quiz results yet.”
- `SessionResultScreen`: list + “Fast answers: N”.

**Change to**

Opening a kid shows **“Rohan did well — 8 out of 10”** (localized bands: Did well / OK / Needs practice) as the hero. Charts collapse under See more. Empty state includes **Start quiz**. Fast-answer wording stays parent-only and non-accusatory.

**Where to change**

| Path | Why |
|------|-----|
| `mobile/.../ui/KidDetailScreen.kt` | Reorder Performance section; reuse existing `results` / bands |
| `mobile/.../ui/KidProfileScreen.kt` | Card summary sentence, not only % |
| `mobile/.../ui/SessionResultScreen.kt` | Align list copy with the same phrases |
| `mobile/.../ui/KidDetailViewModel.kt` | Already observes results — no new API required |

**Implementation pointers**

- Bands already exist in the donut (`≥80` / `50–79` / `<50`) — **reuse**, don’t invent a new scoring service.
- Do not send fast-answer copy to TV (`QuizResultsScreen` must stay praise-only).

**Do not:** New chart libraries. Percentiles.

**Verify:** Kid with 0, 1, and many results. `:mobile:assembleDebug`.

**Implemented (2026-09-10):** Hero sentence first ("Rohan did well — 8 out of 10", bands "did well /
did OK / needs practice" via shared `bandStringRes()`, localized EN/HI/MR); charts collapsed under
"See more"; empty state gains "Start their first quiz" → Content Selection; Kids card shows the same
plain-words summary sentence + ⚠ fast flag; Results list row reads "8 out of 10 — did well".
Fast-answer copy stays parent-only; TV `QuizResultsScreen` untouched (praise-only). `assembleDebug` passes.

---

### SS-EXP-05 — Hide engineering words

| | |
|---|---|
| **Priority** | P0 |
| **Code status** | **Done in code (IMPLEMENTED)** |
| **Work type** | **Enhance** existing screens by **renaming copy only** where possible. No new architecture. |
| **Repos** | `study-shield` **mobile + tv**. |

**Current behaviour (search these strings)**

- Library: `ACTIVATE INTERRUPTER`, `EMERGENCY UNLOCK`, `INTERRUPTION SETUP`, modes including Fill In The Blank (`StudyScreens.kt` `ControlScreen`).
- TV idle: `Interrupter Ready! 🚀`, `Connect using IP`.
- NSD: `Interrupter-$deviceName` (`TvServerService`).
- Pack cards: `Freemium {category}`. Trial dialog: `ExpUpgradePromptDialog`.
- Drawer: Library, ProfData.

**Change to**

Parent-facing: Start quiz, Stop quiz / Unlock TV, TV ready, Child, Result. Banned in UI: interrupter, callback, socket, bundle, seed, command.

**Where to change**

| Path | Why |
|------|-----|
| `mobile/.../ui/StudyScreens.kt` | Library buttons, pack labels |
| `tv/.../MainActivity.kt` idle | Ready to play (pair with SS-DSN-07) |
| `tv/.../res/values/strings.xml` | `app_name` is still Interrupter |
| `tv/.../TvServerService.kt` | User-visible notification title “StudyShield Active” is OK; serviceName can stay for NSD compatibility **or** keep type `_interrupter._tcp` (internal) while display name is the device name |
| `mobile/.../ui/ExpUpgradePromptDialog.kt` | Plain “update class” |

**Implementation pointers**

- **Do not rename** the NSD service **type** `_interrupter._tcp` without updating mobile `StudyRepository` discovery — that would break pairing. Display name ≠ protocol name.
- Emergency unlock must remain one tap + confirm; only the label changes.

**Verify:** grep UI strings for Interrupter/Activate/callback. Pairing still discovers TVs.

**Implemented (2026-09-10):** TV `app_name` → "StudyShield"; NSD `serviceName` is the device's own name
(no "Interrupter-" prefix) while `serviceType` stays `_interrupter._tcp` — discovery/pairing
unchanged. Mobile Library Control: "⚙️ Set up a session", "🚀 Start on TV", "🔓 Unlock TV",
"Fill in the blanks" (all EN/HI/MR); Select Content pack cards show the plain subject/category
(never "Freemium …"; `QuizLoader` keeps a legacy strip for old pack names). TV idle was already
"Ready to play!" + pairing code (SS-EXP-02); `ExpUpgradePromptDialog` copy was already plain.
Verified: grep of `mobile/src` `tv/src` (excluding `.wt` worktrees) shows no banned UI words;
`:mobile:assembleDebug` + `:tv:assembleDebug` pass.

---

### SS-EXP-06 — Pick the child by age and photo, not board jargon

| | |
|---|---|
| **Priority** | P1 |
| **Code status** | **Done in code (IMPLEMENTED)** |
| **Work type** | **Enhance** `KidFormScreen`. Keep avatar chips. Soften default Kid 1. |
| **Repos** | `study-shield` **mobile**. Backend class-grade list already exists (`GET class-grades`). |

**Current behaviour**

- `KidFormScreen`: Full Name, Gender, Birth Year, Grade (from `api.getClassGrades()`), Birthday, **Syllabus (CBSE/ICSE/State)**, Celebration Mascot (`Avatars.IDS`).
- `KidProfileRepository.defaultKid()`: name **Kid 1**, grade **Trial**.
- Backend signup also creates Kid 1 / Trial (`ChildProfileService`).

**Change to**

Required: name + class shown as Nursery / LKG / UKG / 1…10 with typical age. Mascot stays. Syllabus/board **not** on first add (default board `ALL` is already how the bank works). Empty name cannot save. Default Kid 1 should prompt rename on first stepper (SS-EXP-01).

**Where to change**

| Path | Why |
|------|-----|
| `mobile/.../ui/KidFormScreen.kt` | Field order, class chips, hide syllabus on create |
| `mobile/.../data/KidProfileRepository.kt` | Default kid behaviour |
| `mobile/.../data/Models.kt` `KidProfile` | Avatar already stored |
| `study-shield-backend/.../user/` only if default name must change server-side | Keep in sync with mobile default |

**Do not:** Aadhaar, school name, UDISE. Quiz presentation toggles stay on Kid Detail.

**Verify:** Save kid, start quiz, TV greeting uses name + `avatarId` on `InterruptionCommand`.

**Implemented (2026-09-10):** `KidFormScreen` class field is a chip grid with typical ages —
"Nursery · age 3", "Junior KG · age 4", "Sr KG · age 5", "Class N · age N+5" — values are the exact
backend class-grades strings; birth year pre-selects the matching class (mirrors backend
`classNameForAge`); birth year is now optional (name + class required); syllabus/board is omitted on
first add (edit only, board `ALL` default). No `KidProfileRepository` change: the default Kid 1
rename prompt already ships in the first-run stepper (SS-EXP-01 "Edit" + `kid_rename_tip`).
`:mobile:assembleDebug` passes.

---

### SS-EXP-07 — Voice walkthrough for setup

| | |
|---|---|
| **Priority** | P1 |
| **Code status** | **Not in code** |
| **Work type** | **New** on **mobile** using on-device TTS. Pattern already exists on **TV** — copy the idea, not the TV classes. |
| **Repos** | `study-shield` **mobile**. |

**Current behaviour**

- TV `MainActivity` owns `TextToSpeech` for questions (`autoDictation`) and completion greeting. Mobile has **no** setup TTS.

**Change to**

Optional “Speak steps” on first-run screens (SS-EXP-01). One short sentence per screen, then stop. Persist in `SessionManager`. Never block if TTS missing.

**Where to change**

| Path | Why |
|------|-----|
| New helper e.g. `mobile/.../ui/onboarding/SetupTts.kt` | Lifecycle: init / speak / shutdown |
| Stepper / Home (SS-EXP-01) | Toggle + speak on enter |
| `SessionManager` | `speakSetupSteps` flag |

**Do not:** Chatbot. Network voice pack as a hard dependency. Speaking results on speakerphone by default.

**Verify:** Toggle on/off; airplane mode still completes setup.

---

### SS-EXP-08 — One-tap play again for the same child

| | |
|---|---|
| **Priority** | P1 |
| **Code status** | **Not in code** |
| **Work type** | **New** button that **reuses** `StudyViewModel.startSession` + last kid/TV/pack. |
| **Repos** | `study-shield` **mobile** (TV already accepts a new `MCQ` command). |

**Current behaviour**

- After start: “Session Confirmed” dialog; stays on Select Content.
- `SessionResultScreen` is a list; no replay.
- `StudyViewModel.startSession` already builds `InterruptionCommand` from selected pack + `KidQuizConfig`.

**Change to**

On result and Home: **Play again for {name}** → next unused freemium quiz if any, else same subject shuffled (`QuizQuestion.shuffledOptions()` already exists). If TV missing: Find TV, don’t no-op.

**Where to change**

| Path | Why |
|------|-----|
| `mobile/.../ui/SessionResultScreen.kt` | Button |
| `mobile/.../ui/StudyScreens.kt` Home | Same CTA after last result |
| `mobile/.../ui/StudyViewModel.kt` | `replayLastSession()` using last kid id, `lastTvIp`, pack cache |
| `mobile/.../data/PackCache.kt` / `QuizLoader` | Next pack for grade |

**Do not:** Auto-start without parent tap. TV-initiated replay.

**Verify:** Finish quiz, Play again, TV shows next questions, result still on the same `kidName`.

---

### SS-EXP-09 — Shared phone, second adult

| | |
|---|---|
| **Priority** | P1 |
| **Code status** | **Partial — enhance guest + parent overlay** |
| **Work type** | **Enhance** existing guest and `ParentSelectionScreen`. OTP is new if you take that slice. |
| **Repos** | `study-shield` **mobile**; `study-shield-backend` **only if** adding OTP / simplifying parent-required. |

**Current behaviour**

- `WelcomeScreen`: Continue as Guest → `AuthViewModel.guestLogin()` (local session, `isGuest`).
- `ParentSelectionScreen` when API `requiresParentSelection`; **Add New Parent is TODO** in `MainActivity`.
- Sign in: email-or-username + password (`AuthRepository` → `/api/auth/signin`). **No OTP.**
- Backend: email signup, parents CRUD, default parent; **no guest API, no OTP**.

**Change to**

Guest can add kids, pair TV, quiz, see on-device results (already mostly true). Don’t block every launch on parent selection. “Save results” may stay account-based; OTP is optional follow-up, not required to finish this story if guest+skip is solid.

**Where to change**

| Path | Why |
|------|-----|
| `mobile/.../ui/auth/ParentSelectionScreen.kt` | Skip is first-class |
| `mobile/.../MainActivity.kt` | Implement or remove Add Parent TODO |
| `mobile/.../ui/auth/AuthViewModel.kt` | Don’t leave user stuck in `ParentSelectionRequired` |
| `study-shield-backend/.../user/` | Only if parent-required rules change |

**Do not:** School RBAC. TV accounts.

**Verify:** Guest first quiz end-to-end. Signed-in with two parents: skip overlay still reaches Home.

---

### SS-EXP-10 — Kid never sees parent controls

| | |
|---|---|
| **Priority** | P1 |
| **Code status** | **Partial — enhance TV key handling / idle** |
| **Work type** | **Enhance** existing `BackHandler` + `onKeyDown`. Idle copy is SS-DSN-07. |
| **Repos** | `study-shield` **tv**. |

**Current behaviour**

- `MainContent`: `BackHandler` no-op while a command is active.
- `onKeyDown`: pause, then **double-press exit** (`showExitConfirm` / `ExitConfirmOverlay`).
- Results: no buttons, 4s auto-close (`QuizResultsScreen`).
- Idle shows IP.

**Change to**

During quiz, remote only selects answers. Back/Home do not open a menu; optional toast-level “Ask mum/dad to stop on the phone”. Keep auto-close results. Idle must not look like a settings screen (SS-DSN-07). Unlock stays mobile `UNLOCK` / Emergency unlock.

**Where to change**

| Path | Why |
|------|-----|
| `tv/.../MainActivity.kt` | `onKeyDown`, `QuizSession` pause/exit overlay |
| `docs/SCREEN_FLOWS_TV.md` | Document remaining remote behaviour |

**Do not:** TV PIN. Kid profile picker on TV. HTTP.

**Verify:** During MCQ, Back does not exit immediately. Phone unlock still clears state.

---

### SS-EXP-11 — Numeric PIN, not email recovery

| | |
|---|---|
| **Priority** | P2 |
| **Code status** | **Not in code** (Settings switch is a stub) |
| **Work type** | **New** behaviour behind an **existing** Settings row. |
| **Repos** | `study-shield` **mobile**. |

**Current behaviour**

```kotlin
// StudyScreens.kt SettingsScreen
Switch(checked = true, onCheckedChange = {})
```

Headline “Parental PIN” / “Require PIN to unlock manually” — **no storage, no prompt**.

**Change to**

4-digit PIN in `SessionManager` (EncryptedSharedPreferences or existing prefs). Gate **Start quiz** (and unlock-from-phone if you use it), **not** the first-run stepper. Forgot PIN: local reset (child name confirm), not email.

**Where to change**

| Path | Why |
|------|-----|
| `mobile/.../ui/StudyScreens.kt` Settings | Wire the switch + set-PIN dialog |
| `mobile/.../data/SessionManager.kt` | Store hash, not plaintext if easy |
| `StudyViewModel.startSession` | Prompt if enabled |

**Do not:** PIN on TV. Email-only recovery.

**Verify:** Switch off = no prompt. Switch on = Start quiz asks PIN.
