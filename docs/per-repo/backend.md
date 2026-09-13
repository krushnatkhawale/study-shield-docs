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
