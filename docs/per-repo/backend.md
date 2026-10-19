# Per-repo guide: study-shield-backend

`REPOS/study-shield-backend` — the Spring Boot modulith (API).

## Own documentation

Documentation now lives on **this site** (the repo keeps only a pointer in `docs/README.md`):

- [Academic structure (global class matrix & offerings)](../reference/academic-structure.md)
- [Module map, DB schema, config, deployment](../reference/ss-modulith.md)
- [Question bank process & rules](../decisions/question-bank-guide.md) (synced from the repo's former `ss-modulith/docs/QUESTION_BANK_GUIDE.md`)
- [Regression suite guide](../reference/ss-regression-suite.md) · [failure report](../reference/regression-failure-report.md)
- [Tech debt register](../reference/tech-debt.md)
- `question-bank.json` stays in the repo — full curated bank (560 questions) serialized for `POST /api/v1/questions/load`.

## Quick commands

```bash
cd REPOS/study-shield-backend
./gradlew :ss-modulith:test          # run backend tests
curl -X POST "$BASE/api/v1/questions/load" \
  -H "Content-Type: application/json" -d @question-bank.json
```

## Environments & schemas

One Postgres database hosts two schemas — one per environment:

| Profile | Schema | Use |
|---------|--------|-----|
| (default) | `"ss-dev"`  | development |
| `prod` | `"ss-prod"` | production |

- The active profile pins `hibernate.default_schema` (`application.yml` =
  `"ss-dev"`; `application-prod.yml` = `"ss-prod"`). Every Hibernate table resolves
  there — no entity pins a table schema.
- `sql/schema.sql` runs on every startup and creates **both** schemas plus their
  idempotent column backfills, so a fresh `ss-prod` is created automatically.
- Treat both as **separate datasets**: an admin console can switch which one it operates
  on (see [admin per-repo guide](admin.md)).
- Local two-instance demo:
  ```bash
  # dev backend (ss-dev)     — default profile
  ./gradlew :ss-modulith:bootRun
  # prod backend (ss-prod)   — prod profile on a different port
  SPRING_PROFILES_ACTIVE=prod ./gradlew :ss-modulith:bootRun --args='--server.port=8082'
  ```
- Later, migrating prod to its own database is just a `DATABASE_URL` override in the
  `prod` profile — nothing in the code changes.

## Related

- [Architecture: backend](../architecture/backend.md)
- [Decisions: question bank rules](../decisions/question-bank-guide.md)

## Recent changes — October 2026

- **Offering-based academic structure merged to main** (2026-10-19, merge `549606d`):
  the parallel class-grade design was retired. Content is anchored to
  **offerings** (`board_class_subject` = board + class ordinal + global subject):
  - `Subject` is global (unique `code`, no `classGrade`); `ClassLevel` carries
    `Stage` enum (`EARLY_YEARS`/`PRIMARY`/`LOWER_SECONDARY`/`UPPER_SECONDARY`),
    BigDecimal ages, timestamps; `ContentPack` and `Quiz` reference a single
    `BoardClassSubject offering` (`offering_id`).
  - The `Offering`/`ClassGrade` entities, `AcademicStructureSeeder`, and the orphan
    `db/migration/V7__*.sql` files were deleted. Structure is loaded from JSON via
    `AcademicStructureLoadService` (load/export/purge/status endpoints under
    `/api/v1/academic-structure`), with `AcademicStructureBootSeeder` seeding the
    regression profile from `classpath:academic-structure/*.json`.
  - HTTP contracts kept the live admin/mobile shapes: offerings CRUD by
    `boardClassId`+`subjectId`; packs require `offeringId`; board-classes accept
    `classLevelId or ordinal`; class-levels expose `/ordinal/{n}` in addition to CRUD.
  - `sql/schema.sql` gained an idempotent `UPPER(stage)` normalization so rows seeded
    by the retired seeder keep working against the `Stage` enum.
  - Full suite green: ss-modulith 103/103 + regression suite 255/255 against the
    rebuilt jar. Design details: [load/export/purge plan](../plans/academic-structure-load-export-flows.md).
- **StudyGoal** (`studygoal` package: `StudyGoal` entity = `goal` table,
  `StudyGoalController` at `/api/v1/goals` with CRUD plus `/progress?childName=`;
  Monday-start week counts for `WEEKLY_QUIZZES` / `WEEKLY_BEST` (≥80%), default-goal
  auto-seed in `StudyGoalService`).
- The admin console gained **Goals management** and the **academic restore console**
  (backup → purge → load guided flow); see [admin guide](admin.md).
