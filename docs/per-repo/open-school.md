# Per-repo guide: open-school

`REPOS/open-school` — the Open-School / private digital school project.

## Own documentation

- `docs/RESEARCH/` — findings and exploration notes (BootUI fixes, local-LLM exploration,
  feed/notices plans, WhatsApp webhook plan, Spring Boot 4 MockMvc notes, H2 notes, etc.).
- `docs/PLANS/` — extraction rules config plan, `MY_PRIVATE_DIGITAL_SCHOOL_PLAN.md`,
  user onboarding plan.
- `README.md` — repo overview and run instructions.

## Quick commands

```bash
cd REPOS/open-school
./gradlew build        # backend build (Gradle project)
npm install            # Node tooling (playwright e2e)
./run-local.sh         # local run helper
```

## Related

- `REPOS/my-private-digital-school/` — the private digital-school data/repo companion.
