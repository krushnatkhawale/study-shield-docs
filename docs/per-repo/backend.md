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

## Related

- [Architecture: backend](../architecture/backend.md)
- [Decisions: question bank rules](../decisions/question-bank-guide.md)
