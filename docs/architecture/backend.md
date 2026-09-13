# Backend modulith

Source: `study-shield-backend/ss-modulith/docs/ss-modulith.md`.

## Overview

Single deployable Spring Boot application (modular monolith) replacing the previous
5-microservice architecture. Port 8080, single JVM, single PostgreSQL with **per-environment
schemas** (`"ss-dev"` for development, `"ss-prod"` for production — see [Config](#config)).

## Component diagram (C4 Level 3)

The internal modules of the **Backend** container (Spring Modulith), their key
controllers/services, and how the modules depend on each other.

![Backend component diagram (C4 Level 3)](../images/c4-backend-component.svg)

Source: `diagrams/backend-component.puml` (rendered with PlantUML + C4-PlantUML via
`./scripts/diagrams.sh`).

### Module dependency notes

- **content/** is standalone; **user/** depends on content (board/class-grade references);
  **quiz/** depends on content + user (ID references); **feedback/** depends on content
  (validates the question exists). **tv/** uses external IDs only.
- **common/** is used by every module (error handling, CORS, request logging).
- **shared/** exposes `ContentReference` / `UserReference` for cross-module lookups.

## Modules

- **common/** — shared infra: `ResourceNotFoundException`, `GlobalExceptionHandler`,
  `CorsConfig`, `RequestLoggingInterceptor`.
- **content/** — Board, ClassGrade, Subject, ContentPack, Quiz, Question, QuizBundle
  entities. API: `/api/v1/{boards,class-grades,subjects,content-packs,quizzes,questions,quiz-bundles}/**`.
  Packs have a `packType` (FREEMIUM, PREMIUM, LIBRARY, PROMOTIONAL, SEASONAL, COMPLEMENTARY)
  plus optional validity dates. Questions may be tagged with multiple `subjectIds`;
  `POST /questions/{id}/assign-quiz` moves a question between quizzes without deleting versions.
  The Vaadin console is `study-shield-backend-admin` — [per-repo guide](../per-repo/admin.md).
- **user/** — User, ParentProfile, ChildProfile; `/api/auth/**`, `/api/v1/{users,parents,students,children}/**`.
- **quiz/** — QuizAttempt, AttemptAnswer; `/api/v1/quiz-attempts/**`, `/api/v1/attempt-answers/**`.
- **feedback/** — QuestionFeedback (upsert per `(account_id, question_id)`);
  `PUT|GET /api/v1/questions/{id}/feedback`.
- **tv/** — Tv Users, WifiNetwork, ConnectedTV.
- **shared/** — cross-module interfaces (`ContentReference`, `UserReference`).

## Content loading model

The backend **starts empty** (`app.catalog-seeding.enabled: false`). Content is loaded on
demand via **`POST /api/v1/questions/load`**, which auto-creates the whole chain:

```
Board → ClassGrade → Subject → ContentPack → Quiz → Question
```

from items carrying `boardCode` / `className` / `age` / `subject`. See
[question-bank guide](../decisions/question-bank-guide.md) for the full rules.

Quiz bundles are returned per class by `POST /api/v1/quiz-bundles`: **one freemium quiz
per subject that has questions** (Math, EVS, English, Hindi for curated classes). Lazy
`QuizBundleSeeder` fills missing subject quizzes from the curated bank. Issued bundles
are idempotent — rebuild with `POST /api/v1/quiz-bundles/rebuild-catalog` (ADMIN) so
kids are not stuck on an old 2-quiz snapshot.

## Config

- **Schemas** — all tables live in one of two per-environment schemas in the same
  Postgres database. `hibernate.default_schema` is `"ss-dev"` under the default profile
  and `"ss-prod"` under the `prod` profile (`SPRING_PROFILES_ACTIVE=prod`). When prod
  later moves to its own database, point `DATABASE_URL` at it from `application-prod.yml`.
- `spring.jpa.hibernate.ddl-auto=update` (Flyway was removed — see repo-local
  `ss-modulith/docs/ss-modulith.md` for the schema-management notes).
- `spring.sql.init.mode=always` runs `sql/schema.sql` on every boot; it creates **both**
  schemas and idempotently backfills `subjects.display_order`, `users.user_type`, and
  `questions.version_group_id`/`version_number`, so dev and prod stay in lock-step
  regardless of which profile starts first.
- `app.jwt.expiration-ms=86400000`
- `app.catalog-seeding.enabled=false` (on-demand content model)

## Build / test

```bash
cd REPOS/study-shield-backend
./gradlew :ss-modulith:test
```

Android builds require **JDK 21 Corretto**:
`export JAVA_HOME="/Users/hulk/Library/Java/JavaVirtualMachines/corretto-21.0.2/Contents/Home"`.
