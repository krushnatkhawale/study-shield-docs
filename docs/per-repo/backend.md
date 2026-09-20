# Per-repo guide: study-shield-backend

`REPOS/study-shield-backend` — the Spring Boot modulith (API).

## Own documentation

- `ss-modulith/docs/ss-modulith.md` — module map, DB schema, migrations, config, deployment.
- `ss-modulith/docs/QUESTION_BANK_GUIDE.md` — question bank authoring process & rules.
- `TECH_DEBT.md` — known debt at repo root.
- `question-bank.json` — full curated bank (560 questions) serialized for `POST /api/v1/questions/load`.

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

## Recent changes — September 2026

- **Global academic structure** (`ss-modulith/.../content`, `sql/schema.sql`):
  `class_levels` holds 17 ordinals (Playgroup → Class 12); `board_class` carries per-board
  display labels; global `subjects` have a nullable `classGrade` (`SubjectService` accepts a
  null `classGradeId`); `board_class_subject` rows are the per-board offerings. Content packs
  (`ContentPack.offering_id`) and quizzes (`Quiz.offering_id`) carry a nullable offering link,
  with `GET .../offering/{id}` endpoints to list packs/quizzes per offering.
- **Enriched responses:** board-class responses include ordinal/boardCode/boardName
  (`BoardClassService`); offering responses include displayName/ordinal/boardCode/subjectCode/
  subjectName (`OfferingResponse`); board-class create accepts `ordinal` as an alternative to
  `classLevelId` (`BoardClassService`: `classLevelId or ordinal is required`).
- **Seeding & DDL:** `content/seed/AcademicStructureSeeder` (an `ApplicationRunner`,
  idempotent, gated by `app.academic-seeding.enabled`) seeds the 17 levels/boards/offerings.
  The real DDL lives in `sql/schema.sql`; `db/migration/V7__academic_structure*.sql` files are
  documentation-only (commented out, no Flyway in repo).
- **StudyGoal** (`studygoal` package: `StudyGoal` entity = `goal` table,
  `StudyGoalController` at `/api/v1/goals` with CRUD plus `/progress?childName=`;
  Monday-start week counts for `WEEKLY_QUIZZES` / `WEEKLY_BEST` (≥80%), default-goal
  auto-seed in `StudyGoalService`). Test suite (`StudyGoalServiceTest`) green — 76 tests.
- The admin console gained **Goals management** for these endpoints (see
  [admin guide](admin.md)).
