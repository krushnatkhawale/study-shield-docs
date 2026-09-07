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
