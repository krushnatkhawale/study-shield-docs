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
| `./scripts/build.sh` | Build static `site/` for local/static hosts |
| GitHub Actions `pages` | Build MkDocs and publish GitHub Pages on `main` (this repo's origin) |
| GitLab CI `pages` job | Same build into `public/` if the project is mirrored to GitLab |

## Layout

- `docs/index.md` — entry point / index
- `docs/backlog/` — UX stories by role (experience, design, business, reliability, content, quality)
- `docs/architecture/` — overall system, backend modulith, mobile & TV
- `docs/per-repo/` — one guide per app, linking to each repo's own docs
- `docs/decisions/` — ADR log + question-bank process rules
- `mkdocs.yml` — site config (nav, theme)
- `.gitlab-ci.yml` — GitLab Pages (MkDocs → `public/`)
- `scripts/` — setup / serve / build helpers

## Pages (GitHub origin)

Buzz remotes for StudyShield live on GitHub. This repo's `origin` is
`https://github.com/krushnatkhawale/study-shield-docs.git`.

On push to `main`, `.github/workflows/pages.yml` installs MkDocs, builds the
site, and deploys GitHub Pages. After the first successful run the site is at:

https://krushnatkhawale.github.io/study-shield-docs/

If Pages is not on yet: repo **Settings → Pages → Source: GitHub Actions**.

`.gitlab-ci.yml` is kept so the same docs can publish to GitLab Pages if the
project is mirrored there.

Each app keeps its **own** repo-local docs (versioned with the code); this site aggregates
and cross-links them.
