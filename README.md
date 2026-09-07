# StudyShield / Open-School Docs

Aggregated documentation for the StudyShield product family (mobile, TV, backend
modulith, admin) and the Open-School / private digital school. Rendered as a
static site with **MkDocs** (Material theme).

## Quick start (local)

```bash
./scripts/serve.sh     # setup (first run) + live-reload preview at http://127.0.0.1:8000
```

## Commands

| Script | Purpose |
|--------|---------|
| `./scripts/setup.sh` | One-time: create `.venv` + install MkDocs/Material |
| `./scripts/serve.sh` | Preview locally with live reload (http://127.0.0.1:8000) |
| `./scripts/build.sh` | Build static `site/` for deployment (GitHub Pages/Netlify/Render) |

## Layout

- `docs/index.md` — entry point / index
- `docs/architecture/` — overall system, backend modulith, mobile & TV
- `docs/per-repo/` — one guide per app, linking to each repo's own docs
- `docs/decisions/` — ADR log + question-bank process rules
- `mkdocs.yml` — site config (nav, theme)
- `scripts/` — setup / serve / build helpers

Each app keeps its **own** repo-local docs (versioned with the code); this site aggregates
and cross-links them.
