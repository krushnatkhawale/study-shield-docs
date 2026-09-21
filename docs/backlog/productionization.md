---
title: "Productionization Backlog"
tags: [android, play-store, productionization]
status: active
created: 2026-09-21
---

# Productionization backlog — Play Store readiness (mobile + TV)

Source: code audit of `study-shield` (mobile + TV) on 2026-09-20. Each card below is an
**LLM implementation brief** — copy one card (heading through **Verify**) and paste it
into Buzz per [llm-brief.md](llm-brief.md). Work **down the suggested order**; do not
skip ahead to console paperwork before code blockers are green.

## Suggested order

1. SS-PROD-03 listing shape (one vs two listings) — decision needed from owner first.
2. SS-PROD-02 signing key + build config.
3. SS-PROD-01 API 36 bump + behavior review.
4. SS-PROD-04 TV permission declarations/justifications.
5. SS-PROD-05 location scoping + disclosure.
6. SS-PROD-06 cleartext scoping.
7. SS-PROD-07 signed AAB build + pre-submission checklist.
8. SS-PROD-08 console paperwork (owner-side; LLM prepares assets/texts only).

---

## SS-PROD-01 Target SDK 36 for mobile

**Outcome:** Mobile app targets API 36 (new-app requirement since 31 Aug 2026). TV stays 34+.

**Repo / files:** `study-shield` — `mobile/build.gradle*` (`compileSdk`, `targetSdk`),
`gradle/libs.versions.toml` (AGP 8.7.2 → 8.8+), `gradle-wrapper.properties` if needed.

**Do:**
- Bump `compileSdk`/`targetSdk` to 36 for `:mobile`; keep `:tv` at 35 (≥34 OK).
- Bump AGP to 8.8+ and Gradle wrapper to the matching version.
- Review Android 36 behavior changes touching this app: edge-to-edge, photo picker,
  foreground-service types, `targetSdk` notification changes. Fix or document each.
- Full clean build of both modules + install/run smoke on a device/emulator.

**Do not:** change `applicationId`, permissions, or minSdk in this card.

**Verify:** `./gradlew :mobile:assembleDebug :tv:assembleDebug` green; `aapt dump badging`
(or `apkanalyzer`) shows mobile `targetSdkVersion:'36'`; app launches, start-quiz flow works.

---

## SS-PROD-02 Upload key + signing config

**Outcome:** A guarded upload key exists and release builds produce signed AABs.

**Repo / files:** `study-shield` — new `keystore.properties.example`, `mobile/build.gradle*`,
`tv/build.gradle*` signingConfigs (only if two listings — see SS-PROD-03), `.gitignore`.

**Do:**
- Generate upload keystore **once** (owner keeps backup + passwords; never commit them).
- Add `signingConfigs.release` reading from `keystore.properties` (gitignored) with a
  committed `keystore.properties.example`. Debug builds unchanged.
- Document key custody: where the keystore + passwords live, who backs them up.
- If two listings (SS-PROD-03 option B), add signing for both modules.

**Do not:** commit the keystore, real passwords, or `keystore.properties`.

**Verify:** `./gradlew :mobile:bundleRelease` (and `:tv:bundleRelease` if applicable)
produces signed `.aab`; `jarsigner -verify` passes; `git status` shows no secrets.

---

## SS-PROD-03 Listing shape decision (one vs two listings)

**Outcome:** Owner decision recorded: one listing (single appId, TV support merged) or two
listings (TV gets its own `applicationId`).

**Context:** Both modules currently share `applicationId com.kaushalya.interrupter`.
Two artifacts cannot share one ID on Play.

**Options:**
- A. One listing: merge leanback/TV support into the mobile app (or ship mobile only
  first, add TV later via same listing).
- B. Two listings: e.g. mobile keeps `com.kaushalya.interrupter`, TV becomes
  `com.kaushalya.interrupter.tv` (exact IDs for owner to confirm).

**Do:** Record decision in this file + per-repo mobile-tv guide; if B, rename TV
`applicationId`/`namespace` as needed and smoke-build both.

**Verify:** Decision line filled in; both modules build; no ID collision remains.

**Decision:** _PENDING — owner to confirm A or B._

---

## SS-PROD-04 TV sensitive permissions + declarations

**Outcome:** TV manifest permissions each have a Play declaration + in-code justification,
or are removed if unused.

**Repo / files:** `study-shield` — `tv/src/main/AndroidManifest.xml`, related services.

**Permissions in scope:** `SYSTEM_ALERT_WINDOW`, full-screen intent
(`USE_FULL_SCREEN_INTENT`), special-use foreground service.

**Do:**
- For each: confirm it is actually needed at runtime; remove if not.
- Keep only the minimal set; note the foreground-service type declared.
- Draft the Play declaration text + in-app rationale for each kept permission
  (append to this card or `per-repo/mobile-tv.md`).
- Note: full-screen intent is heavily restricted — prefer standard notifications
  unless the use case qualifies.

**Verify:** Manifest diff reviewed; each kept permission has declaration text;
app's block/break flows still work on TV.

---

## SS-PROD-05 Location request scoping (Wi-Fi discovery)

**Outcome:** Fine location is requested only in the TV-pairing flow with parent-gated
rationale + prominent disclosure — not at startup for all users.

**Repo / files:** `study-shield` — `mobile/...` discovery/permission flow,
`AndroidManifest.xml` location entries.

**Do:**
- Move location permission request from startup to the TV-pairing/discovery entry point.
- Add a parent-visible rationale screen/text before the system prompt + a prominent
  disclosure (why location is needed for Wi-Fi discovery, no tracking).
- Kids/Families-policy lens: keep copy parent-directed, no dark patterns.

**Verify:** Fresh install → no location prompt until pairing flow; rationale +
disclosure shown first; discovery still finds TV after grant; denial degrades gracefully.

---

## SS-PROD-06 Cleartext traffic scoping

**Outcome:** `usesCleartextTraffic=true` is scoped to local/LAN hosts (TV talk) or
justified for Play.

**Repo / files:** `study-shield` — `mobile/.../AndroidManifest.xml`,
`res/xml/network_security_config.xml` (new or existing).

**Do:**
- Replace global cleartext with a `network_security_config` allowing cleartext only
  for local hosts (e.g. private/LAN ranges used for TV communication).
- Keep all backend/admin traffic on HTTPS.
- Write the Play justification sentence for the remaining cleartext exception.

**Verify:** Release manifest + config reviewed; backend calls still HTTPS-only;
mobile↔TV LAN flows work; justification text recorded.

---

## SS-PROD-07 Signed AAB + pre-submission checklist

**Outcome:** Signed release AAB(s) built from main, with version + pre-upload checks done.

**Depends on:** SS-PROD-01 through SS-PROD-06.

**Do:**
- Bump `versionCode`/`versionName` per release discipline.
- Build signed `:mobile:bundleRelease` (+ `:tv:bundleRelease` if two listings).
- Run pre-upload checks: targetSdk, applicationId(s), permissions dump, 64-bit,
  debuggable=false, no secrets in bundle, launcher icons + leanback banner (TV),
  feature-graphic/screenshots list status.
- Record artifact paths + checksums in the release notes.

**Verify:** Checklist all ticked; AAB(s) install via internal-test track path;
`targetSdkVersion` and IDs confirmed in artifact.

---

## SS-PROD-08 Console paperwork (owner-side; LLM preps drafts)

**Outcome:** All Play Console items tracked; LLM prepares every draftable asset/text.

**Owner-only (LLM cannot do):** Play Console account + payments, app creation,
production/tester tracks, content-rating questionnaire submission, Families /
Designed-for-Families declarations, Data safety submit.

**LLM drafts to prepare:**
- App listing: title, short/long description, categorization, contact details.
- Privacy policy URL content (hosting is owner-side).
- Data safety form answers (data collected/shared, purposes) derived from code
  (location, network, no ads — verify against manifest + SDKs).
- Content rating + Families declaration inputs.
- Closed-test plan: tester list template, test instructions, feedback loop
  (Play requires a test track before production for new accounts).

**Verify:** Each item has status (draft/owner-action/done) and a path to the draft text.
