# Per-repo guide: study-shield-backend-admin

`REPOS/study-shield-backend-admin` — Vaadin 24 admin console for the StudyShield modulith API.

## What it is for

Operators manage **curriculum and delivery packs** without curl:

| Area | Capabilities |
|------|----------------|
| Boards | Add / update / delete / disable |
| Classes | Add / update / delete, attached to a board |
| Subjects | Add / update / delete / reorder per class |
| Packs | Freemium, premium, library, promotional, seasonal, complementary — enable/disable, optional date window |
| Quizzes | Add / update / delete; always play the **latest question version** |
| Question bank | Add / update / delete with versioning; tag **one or more subjects**; add/remove from a quiz without deleting the bank copy |
| Home | Counts + **Rebuild freemium catalog** (drops issued kid bundles) |

Login is the backend **admin** account (`POST /api/auth/admin-signin`), not a local `admin/admin123` user.

## Run

```bash
cd REPOS/study-shield-backend-admin
./gradlew :app:bootRun
```

Open http://localhost:8081/login

Point at a backend with:

```
STUDYSHIELD_BACKEND_URL=http://localhost:8080
```

(or the Render URL). Theme toggle (light/dark) is in the header. Theme files are at
`study-shield-backend-admin/src/main/frontend/themes/studyshield/` (Vaadin looks from the
**repo root**, not the `app/` module).

## Environments (dev / prod)

The header has an **Environment** dropdown (`dev` / `prod`). It switches which backend
the console talks to for all CRUD:

| Dropdown | Backend URL | Backend schema |
|----------|-------------|----------------|
| `dev`  | `studyshield.backend.base-url` (`STUDYSHIELD_BACKEND_URL`) | `"ss-dev"` (default profile) |
| `prod` | `studyshield.backend.prod-base-url` (`STUDYSHIELD_BACKEND_PROD_URL`) | `"ss-prod"` (`prod` profile) |

- The schema follows the **backend's** runtime profile, so to see the dropdown take
  effect you run two backend instances (see [backend guide](backend.md) for the local
  two-instance demo). Defaults: `dev` → Render URL, `prod` → `http://localhost:8082`.
- Switching an environment clears the cached sign-in token, so the next operation
  re-authenticates against the newly selected backend. The selection is a single active
  environment for the whole console (shared across browser sessions).
- This lets the same console manage dev data, then point at prod purely by flipping the
  dropdown — no restart, no second deploy.

## How questions and quizzes fit

- A **question** is versioned. Saving an edit creates a new version; quizzes load `supersededBy == null`.
- A question is **tagged** with one or more subject ids (`subjectIds`).
- A question **belongs to one quiz at a time** for delivery. **Remove from quiz** moves it to that subject's **Library** pack (not a hard delete). **Add from bank** assigns it onto the open quiz.
- A **pack** is the delivery envelope (freemium vs seasonal, etc.). Disable a pack to hide it from kids.

## Related

- [Architecture: backend](../architecture/backend.md)
- [Per-repo: backend](backend.md)
