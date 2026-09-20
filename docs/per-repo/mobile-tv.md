# Per-repo guide: study-shield (mobile & TV)

`REPOS/study-shield` — Android Studio project with `mobile/` and `tv/` modules.

## Own documentation

- `docs/` — product vision, screen flows, plans
- `quiz-schema.md`, `quiz-design-proposal.md` — quiz data design
- `development-history/` — dated phase notes

## Quick commands

```bash
export JAVA_HOME="/Users/hulk/Library/Java/JavaVirtualMachines/corretto-21.0.2/Contents/Home"
cd REPOS/study-shield
./gradlew :mobile:assembleDebug :tv:assembleDebug
```

## Related

- [Architecture: mobile & TV](../architecture/mobile-tv.md)

## Recent changes — September 2026

All paths below are under `mobile/src/main/java/com/kaushalya/interrupter/` unless noted.

- **Quiz Stats screen** (`ui/QuizAnalyticsScreen.kt`, via chart icon): donut of 4-band
  distribution, 14-day bars, attempt history, plus a "needs attention" banner for attempts <30%.
- **4-band system** shared via `bandStringRes` (`ui/KidDetailScreen.kt`): Best ≥80 /
  Better 50–79 / Good 30–49 / Needs attention <30 (`band_attention` in `res/values/strings.xml`),
  surfaced on kid profile, session results, and Home2 attention shelf.
- **Kid avatars** (`data/Avatars.kt` via `Models.kt`, `data/AppDatabase` v12→v13 `avatar`
  column, `KidAvatar` composable): photo or initials everywhere, including the kid-form
  mascot picker (`ui/KidFormScreen.kt`).
- **Light-theme enforcement**, animated splash fused to routing (`MainActivity.kt` splash
  overlay gating on routing resolution), and drawer back-stack fix (`ui/StudyScreens.kt`
  `popBackStack` wiring that preserves nav history).
- **Home2 experimental parent hub** (`StudyScreens.kt` `Home2Screen`): greeting,
  continue-learning, attention shelf, backend goals section, 2×2 shortcuts
  (Start Quiz / Results / Kids / Quick Actions).
- **Quick Actions screen** (`StudyScreens.kt` `QuickActionsScreen`): unified block/break/
  scheduled TV commands.
- **Kid delete syncs to backend** (`data/KidProfileRepository.kt`, `data/PendingOp.kt`,
  `network/ApiService.kt deleteKid`): remote delete attempt with offline `PendingOp`
  (`DELETE_KID`) queue drained on reconnect; sticky Delete bar on kid detail.
