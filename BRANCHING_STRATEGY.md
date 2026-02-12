# 🚀 Branching & Release Strategy Proposal

## Problem Statement

With a single-branch workflow where feature/fix branches go directly to staging, we face several issues:

| Problem | Impact |
|---------|--------|
| **Overwriting in-flight work** | Deploying one ticket can override changes from another ticket already in staging |
| **Background jobs disruption** | Jobs awaiting QA can be replaced, leading to unexpected behavior |
| **No stacked PRs in staging** | Everything becomes a manual, sequential process |
| **Redundant test setups** | Shared logic across tickets requires separate test rounds instead of being validated together |

### Example: Why This Matters

Imagine two tickets that touch shared logic:

- **Ticket 1** — Delivery with a new change  
- **Ticket 2** — Billing with a new change  

In a single-branch model, you must deploy Ticket 1 → test → deploy Ticket 2 → test, sequentially. But if both tickets live on a shared `develop` branch (as we do today), we only need **one staging deployment** to validate both changes together — saving time and reducing manual coordination.

---

## Proposed Branch Structure

```
main ─────────────────────────────────────────────► (latest stable code)
  │
  └── develop ────────────────────────────────────► (integration branch)
        │
        ├── feat/new-feature ─── PR ──► develop
        ├── feat/another-feature ── PR ──► develop
        ├── fix/bug-fix ──────── PR ──► develop
        │
        └──────── merge ──► main ──► release/v1.2.0
```

### Branch Roles

| Branch | Purpose | Deploys To |
|--------|---------|------------|
| `main` | Latest **stable**, production-ready code | — |
| `develop` | Integration branch where all feature/fix branches merge into | **Staging** (automatic) |
| `release/v*` | Immutable release snapshot, tagged and deployed | **Production** (automatic on push) |
| `feat/*` | Short-lived branches for new features | — (PR → `develop`) |
| `fix/*` | Short-lived branches for bug fixes | — (PR → `develop`) |

---

## Workflow Overview

### 1. Feature / Fix Development

```
1. Branch off from `develop`
2. Work on the feature or fix
3. Open a PR targeting `develop`
4. Code review & approval
5. Merge (squash) into `develop`
```

> Once merged into `develop`, the code is **automatically deployed to staging** for QA.

### 2. Releasing to Production

```
1. All QA-approved changes sit in `develop`
2. Merge `develop` → `main` (fast-forward)
3. Tag the release (timestamp-based)
4. Push the release branch: `release/v<TAG_NAME>`
5. Production deployment triggers automatically
```

> `develop` → `main` is always a **fast-forward merge**, keeping history clean and mirroring safe.

### 3. Release Notes & Tagging

| Automation | Strategy |
|------------|----------|
| **Tag naming** (`tag_release.yml`) | Timestamp-based (e.g., `v2026.02.12.1`) |
| **Release notes** (`release_notes.yml`) | Auto-generated from PR labels: `feat`, `fix`, `chore`, etc. |
| **Release branch** (`release_notes.yml`) | Pushes `release/<TAG_NAME>` branch automatically |
| **Production deploy** (`deploy_production.yml`) | Triggers on any push to a `release/*` branch |

---

## Hotfix Strategy

When a critical bug is found in the latest production release, speed matters. Here are two paths depending on urgency:

### 🔴 Critical — Can't Wait for Review

> *Production is broken and needs an immediate fix.*

```
1. Push the fix commit directly to `release/<LATEST_TAG_NAME>`
   → Production deploys automatically
2. Open a PR to `develop` with the same fix
   → Keeps develop in sync
```

### 🟡 Standard — Can Wait for Team Review

> *Bug is important but not blocking. No untested work on `develop` is in the way.*

```
1. Open a PR with the fix targeting `develop`
2. After review & merge, create PR `develop` to `main`
   → PR is merged into main, tagged, release notes generated, release branch deployed
```

> **Key insight:** We don't need to worry about the history of `release/*` branches. Need a quick fix deployed? Just push it there.

---

## Why This Works

### ✅ Staging Stays Reliable
Multiple tickets can coexist on `develop` and be tested together in staging — no more sequential, manual deployments.

### ✅ Production Is Always Intentional
Code only reaches production through a deliberate `develop` → `main` → `release/*` flow, or through an explicit hotfix push.

### ✅ Fast-Forward Guarantees
`develop` → `main` is always fast-forwarded, so mirroring stays safe and the history remains linear.

### ✅ Hotfixes Are Fast
Critical fixes can bypass the full flow by pushing directly to the release branch — with a follow-up PR to keep `develop` in sync.

### ✅ Keep using feature flag as a security plus
If we are going to merge develop -> main, and we have a untested feature, this feature will not affect production users since it is using feature flags.

---

## Flow Diagram

```
  feat/new-feature ──┐
                     │  PR + Review
  fix/bug-fix ───────┤
                     │
                     ▼
               ┌──────────┐        auto deploy
               │  develop  │ ─────────────────► Staging
               └────┬─────┘
                    │
                    │ fast-forward merge (when ready to release)
                    ▼
               ┌──────────┐
               │   main    │
               └────┬─────┘
                    │
                    │ tag + push release branch
                    ▼
            ┌────────────────┐     auto deploy
            │ release/v1.2.0 │ ──────────────► Production
            └────────────────┘
                    ▲
                    │
              hotfix push (if critical)
```

---

## GitHub Actions Summary

| Workflow | Trigger | Action |
|----------|---------|--------|
| `tag_release.yml` | Manual / merge to `main` | Creates a timestamp-based tag |
| `release_notes.yml` | New tag created | Generates release notes from PR labels, pushes `release/<TAG>` branch |
| `deploy_staging.yml` | Push to `develop` | Deploys to staging environment |
| `deploy_production.yml` | Push to `release/*` | Deploys to production environment |

---

## FAQ

**Q: What if `develop` has untested features when I need to release?**  
A: No problem. Only merge the tested commits from `develop` to `main`. Untested work stays on `develop` and won't reach production.

**Q: Can two hotfixes happen at the same time?**  
A: Yes. Both can be pushed to the latest `release/*` branch. Each push triggers a production deploy.

**Q: Do we ever deploy `develop` directly to production?**  
A: Never. `develop` only deploys to staging. Production is exclusively served by `release/*` branches.

**Q: What happens to old release branches?**  
A: They remain as historical snapshots. Only the latest `release/*` branch receives hotfixes. Old ones can be cleaned up periodically.

**Q: What happens if we have a lot of bugs in a release and our clients are mad, everyting is burning?**  
A: Just redeploy previous stable tag.
