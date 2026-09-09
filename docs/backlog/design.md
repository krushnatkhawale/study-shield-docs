# Design — LLM implementation briefs

Copy **one** story into Buzz. Invariants: [llm-brief.md](llm-brief.md). TV stays 10-foot and thin.

---

### SS-DSN-01 — TV quiz is four huge choices, nothing else

| | |
|---|---|
| **Priority** | P0 |
| **Code status** | **Partial — enhance `QuizUI` / `QuizSession`** |
| **Work type** | **Enhance** existing 2×2 tiles. Do not rebuild the quiz engine. |
| **Repos** | `study-shield` **tv**. Manual FITB mode on mobile Library is out of scope except hiding it (SS-EXP-05 / SS-CNT-01). |

**Current behaviour**

- `QuizUI` in `tv/.../MainActivity.kt`: 2×2 `Button`s, height 100.dp, focus scale 1.08, D-pad, read-lock hint.
- `TrueFalseUI` for two options.
- `QuizSession` shows progress **bar + “Question N of M”**, pause control, optional `ExitConfirmOverlay`.
- `FitbUI`: on-screen letter grid (overkill for young kids).

**Change to**

Question + up to four huge answers from 3 metres. Quiet dots instead of “Question N of M” as hero. No skip. FITB not used for bank quizzes (SS-CNT-01). Pause/exit: see SS-EXP-10.

**Where to change**

| Path | Why |
|------|-----|
| `tv/.../MainActivity.kt` `QuizUI`, `TrueFalseUI`, `QuizSession` | Layout, progress, chrome |
| `tv/docs/TV_QUIZ_DESIGN_DECISIONS.md` | Keep in sync |

**Implementation pointers**

- Questions arrive as `InterruptionCommand.questions` (`QuizQuestion(question, options, answer)`). No images until SS-DSN-02.
- Focus: keep `focusedContainerColor` + scale; colour-only is not enough.

**Do not:** New Activities. HTTP. Leaderboards.

**Verify:** `:tv:assembleDebug`. D-pad through 4 options on a TV/emulator.

---

### SS-DSN-02 — Nursery/KG questions are pictures + voice

| | |
|---|---|
| **Priority** | P0 |
| **Code status** | **Not in code** (TTS toggle exists; images do not render; dictation defaults **off**) |
| **Work type** | **New** image fields on the protocol + bank items. **Enhance** `autoDictation` default for young grades. |
| **Repos** | `study-shield` **mobile + tv**; `study-shield-backend` (bank + question JSON). |

**Current behaviour**

- TV `QuizQuestion`: `question`, `options`, `answer` — **no image**.
- Mobile `Models.kt` has unused `imageUrl` on a different DTO.
- `KidQuizConfig.autoDictation = false`.
- Bank `SeedQuestion` is text-only; `QuestionBankContent` Nursery is MCQ/TF English text.

**Change to**

Nursery / LKG / UKG can show a question image and image options (all images or all text, never mixed — `study-shield/quiz-schema.md`). Auto-dictation **on by default** for those grades unless parent turns it off on Kid Detail.

**Where to change**

| Path | Why |
|------|-----|
| `mobile/.../data/Models.kt` **and** `tv/.../InterruptionCommand.kt` | Add optional image URLs/base64 to `QuizQuestion` **on both** |
| `tv/.../TvServerService.kt` + `MainActivity.handleIntent` | Forward extras / JSON |
| `tv/.../MainActivity.kt` `QuizUI` | Render image tiles same size as text tiles |
| `mobile/.../ui/StudyViewModel.kt` | Map loader questions → command |
| `mobile/.../data/QuizLoader.kt` | Pass images through |
| `study-shield-backend/.../content/entity` + `QuestionBankContent` / load DTO | Author picture items or URLs |
| `KidQuizConfig` / `KidForm` grade | Default `autoDictation=true` for Nursery/LKG/UKG |

**Implementation pointers**

- TV still **must not** download from the internet if we can avoid it: prefer images **already on the phone** (pack cache) sent in the command (bounded size) or as `file://` is impossible across devices — so **embed small assets in the command JSON** or ship a tiny drawable set in the **TV APK** keyed by resource id. Prefer **resource ids / bundled drawables in both APKs** over TV HTTP.
- TTS: existing `LaunchedEffect(currentIndex, autoDictation, …)` in `QuizSession` — only change the default.

**Do not:** TV Retrofit. AI-generated architecture diagrams. Mixing text and image options in one question.

**Verify:** Young-grade quiz: spoken question, picture options, parent can disable TTS on Kid Detail.

---

### SS-DSN-03 — Mobile first-run has no hamburger maze

| | |
|---|---|
| **Priority** | P1 |
| **Code status** | **Not in code** |
| **Work type** | **Enhance** `MainScreen` drawer list. Pair with SS-EXP-01. |
| **Repos** | `study-shield` **mobile**. |

**Current behaviour**

`StudyScreens.kt` `MainScreen` `items`: Home, Library, Connected TVs, Kids, Results, Settings, **ProfData**; plus Quiz Setup / Parents if not guest.

**Change to**

First-run: Home + Child + Result (or the 3-step Home only). ProfData **never** in production (`BuildConfig.DEBUG`). After first quiz, More reveals TVs / Settings.

**Where to change**

| Path | Why |
|------|-----|
| `mobile/.../ui/StudyScreens.kt` `items` | Filter by `hasCompletedFirstQuiz` + `BuildConfig.DEBUG` |
| `mobile/.../data/SessionManager.kt` | Flag |
| `docs/SCREEN_FLOWS_MOBILE.md` | Drawer map |

**Do not:** Six-item bottom nav. Removing Library’s start-session capability — **move** it to Home Start quiz.

**Verify:** Guest and signed-in; ProfData absent in release assemble.

---

### SS-DSN-04 — Mascot is present during the quiz, not only at the end

| | |
|---|---|
| **Priority** | P1 |
| **Code status** | **Partial — enhance `LiveMascot` usage** |
| **Work type** | **Reuse** code-drawn `LiveMascot` in `QuizSession`, not only `QuizResultsScreen`. |
| **Repos** | `study-shield` **tv**. |

**Current behaviour**

`LiveMascot(avatarId)` is composed in `QuizResultsScreen` (completion). `avatarId` already arrives on `InterruptionCommand` / intent extra `AVATAR_ID`. 12 styles in `MainActivity.kt`.

**Change to**

Small corner mascot during questions (idle blink). Hop on correct, gentle on wrong. Keep 4s celebration at end. No extra screens.

**Where to change**

| Path | Why |
|------|-----|
| `tv/.../MainActivity.kt` `QuizSession` | Compose `LiveMascot` with a smaller modifier; drive expression from last answer |

**Do not:** New illustration pipeline. Lottie bloat. Shop/wardrobe. Mascot picker on TV (picker stays on mobile Kid Form).

**Verify:** `:tv:assembleDebug`. Avatar matches kid profile.

---

### SS-DSN-05 — Living-room contrast and D-pad focus

| | |
|---|---|
| **Priority** | P1 |
| **Code status** | **Partial — enhance existing focus/scale** |
| **Work type** | **Enhance** `QuizUI` colors/padding. |
| **Repos** | `study-shield` **tv**. |

**Current behaviour**

Green gradient quiz; focused tile white + 1.08 scale; padding ~40.dp.

**Change to**

Focus visible from 3 m (border + scale, not colour-only). Safe overscan. No flashing.

**Where to change:** `tv/.../MainActivity.kt` `QuizUI` / `TrueFalseUI` modifiers.

**Do not:** Parent themes on TV.

**Verify:** Android TV emulator D-pad; cheap stick if available.

---

### SS-DSN-06 — Bilingual labels: icon + short word

| | |
|---|---|
| **Priority** | P2 |
| **Code status** | **Partial** |
| **Work type** | **Enhance** quiz review icons; depends on SS-EXP-03 for real bilingual chrome. |
| **Repos** | `study-shield` **mobile**. |

**Current behaviour**

`QuizReviewScreen.kt`: ThumbUp / ThumbDown / Flag **icon-only** (contentDescription). Screen-flow doc currently requires icon-only.

**Change to**

Visible short caption in app locale (SS-EXP-03). Long-press still OK. Did well / Needs practice not colour-only (SS-EXP-04).

**Where to change:** `mobile/.../ui/quiz/QuizReviewScreen.kt`.

**Do not:** Wait on a custom icon font.

**Verify:** TalkBack + visible label.

---

### SS-DSN-07 — Idle TV says ready to play; IP is secondary

| | |
|---|---|
| **Priority** | P2 (do with SS-EXP-02 / SS-EXP-05 — cheap and high impact) |
| **Code status** | **Not in code** |
| **Work type** | **Enhance** the idle `else` branch in `MainContent`. |
| **Repos** | `study-shield` **tv**. |

**Current behaviour**

```text
{deviceName}
Interrupter Ready! 🚀
Connect using IP: {ip}
```

15s ring then `moveTaskToBack`.

**Change to**

Mascot optional + “Ready to play” + large pairing code (SS-EXP-02). Device name + IP in footer. Keep 15s yield so the TV is not hijacked.

**Where to change:** `tv/.../MainActivity.kt` idle `Column`. Pairing code source: SS-EXP-02 / `TvServerService`.

**Do not:** Idle content browser. Ads.

**Verify:** `:tv:assembleDebug`. Phone still connects (NSD + code).
