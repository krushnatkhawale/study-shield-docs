# Business value — LLM implementation briefs

Copy **one** story into Buzz. Invariants: [llm-brief.md](llm-brief.md).

---

### SS-BIZ-01 — Time-to-first-quiz is the north star

| | |
|---|---|
| **Priority** | P1 |
| **Code status** | **Not in code** |
| **Work type** | **New** counters. Depends on SS-QLT-05 for a pipeline. Until then, a local log / debug screen is enough. |
| **Repos** | `study-shield` **mobile** (events); optional `study-shield-backend`. |

**Current behaviour:** No analytics SDK, no funnel.

**Change to:** Count app_open → child_saved → tv_paired → quiz_started → result_received (app version + language only). Sprint review uses this.

**Where to change**

| Path | Why |
|------|-----|
| New `mobile/.../data/ActivationLog.kt` or SS-QLT-05 events | Fire from `MainActivity`, Kid save, `startSession`, result listener |
| `StudyViewModel.startSession` / `StudyRepository` result callback | quiz_started / result_received |

**Do not:** Third-party ads SDK. Session replay. Kid names in analytics.

**Verify:** One debug dump of the funnel after a guest first quiz.

---

### SS-BIZ-02 — WhatsApp share of a win

| | |
|---|---|
| **Priority** | P1 |
| **Code status** | **Not in code** |
| **Work type** | **New** share on existing results UI. |
| **Repos** | `study-shield` **mobile**. |

**Current behaviour:** `SessionResultScreen` / Kid Detail have no `ACTION_SEND`.

**Change to:** After a result, “Send to WhatsApp” image card: mascot, first name, subject, X out of Y, StudyShield. Never auto-share. Neutral/proud copy only.

**Where to change**

| Path | Why |
|------|-----|
| `mobile/.../ui/SessionResultScreen.kt` | Button + Compose-to-bitmap or simple share text as v1 |
| `KidDetailScreen.kt` | Optional same action on latest result |

**Implementation pointers:** `Intent.ACTION_SEND` + `setPackage("com.whatsapp")` with fallback to chooser. No extra child PII.

**Do not:** In-app social feed. Sharing wrong-answer dumps.

**Verify:** Share sheet opens; TV unchanged.

---

### SS-BIZ-03 — School-syllabus trust without a brochure

| | |
|---|---|
| **Priority** | P1 |
| **Code status** | **Done in code** for bundle metadata. **Enhance copy** on pack cards. |
| **Work type** | **Enhance** `ContentSelectionScreen` labels. Backend already returns `className`, `boardCode`, `subjects`. |
| **Repos** | `study-shield` **mobile** (copy). Backend only if you want a display field. |

**Current behaviour**

- `QuizBundleResponse`: className, boardCode, subjects.
- Pack UI subtitle **“Freemium {category}”** (`StudyScreens.kt` ContentSelectionScreen).
- `ExpUpgradePromptDialog` mentions class & syllabus.

**Change to:** Cards: “Class 3 · Math” + “School topics”. No official-board claim. Pair with SS-EXP-05 (drop Freemium).

**Where to change:** `mobile/.../ui/StudyScreens.kt` pack card composable; maybe `StudyContent` display helpers.

**Do not:** PDF prospectus. Rebuild catalog.

**Verify:** Select Content shows class + subject in parent language (if SS-EXP-03 done).

---

### SS-BIZ-04 — Low-end Android is the default device

| | |
|---|---|
| **Priority** | P1 |
| **Code status** | **Partial** (minSdk already 24/23) |
| **Work type** | **Enhance** discipline: size budget + don’t add TV HTTP/images unbounded (SS-DSN-02). |
| **Repos** | `study-shield` **mobile + tv**. Team: SS-QLT-03. |

**Current behaviour:** `mobile/build.gradle` minSdk 24; `tv/build.gradle` minSdk 23. TV has no Retrofit.

**Change to:** Track TV APK size on PRs (SS-QLT-04). Picture quizzes must not require a 300 MB TV APK. No ads.

**Where to change:** Gradle `resConfigs`; SS-DSN-02 asset strategy; PR template.

**Do not:** Drop old APIs without measuring.

**Verify:** `:tv:assembleDebug` size note in the PR.

---

### SS-BIZ-05 — Freemium unlock after the family has won once

| | |
|---|---|
| **Priority** | P2 |
| **Code status** | **Partial — cap exists, paywall does not** |
| **Work type** | **New** paywall **on mobile only** after existing 2-quiz cap. Do not confuse with Trial class-upgrade dialog. |
| **Repos** | `study-shield` **mobile** + `study-shield-backend` entitlements if you persist “unlocked”. |

**Current behaviour**

- `QUIZZES_PER_CLASS = 2`, `ContentTier.FREEMIUM`.
- `ExpUpgradePromptDialog`: after first **Trial** quiz, ask to **update class** — not pay.

**Change to:** First two class quizzes always play. Then one mobile sentence “More class 4 quizzes”. Never on TV. Guest results still count.

**Where to change**

| Path | Why |
|------|-----|
| `QuizBundleService` / ContentTier | Premium selection when entitled |
| Mobile Select Content empty/locked state | Copy |
| Keep `ExpUpgradePromptDialog` for Trial→real class | Different job |

**Do not:** Ads on wrong answers. TV paywall. Per-question IAP.

**Verify:** Third pack for a class blocked on phone; TV never shows a pay UI.

---

### SS-BIZ-06 — APK share path for places Play is painful

| | |
|---|---|
| **Priority** | P2 |
| **Code status** | **Not in code** |
| **Work type** | **New** docs + version labels. Apps already have versionName. |
| **Repos** | `study-shield-docs` (guide); `study-shield` mobile/tv first screens for “Phone app” vs “TV app”. |

**Change to:** Picture guide (Hindi/English): install phone APK, TV APK from USB/Play, same Wi-Fi. Distinct launcher labels.

**Where to change:** This docs site; `mobile/.../res/values/strings.xml` `app_name`; TV `app_name` (still “Interrupter” — SS-EXP-05).

**Verify:** Someone can tell the two APKs apart from the icon/name.
