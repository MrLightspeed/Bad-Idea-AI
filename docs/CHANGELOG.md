# Executive Summary

SARAH’s upgrade is faster, more reliable, and easier to use. Replies are about **35 %** quicker, a persistent **Menu 📋** button keeps controls handy, and media downloads over HTTP/2 are smoother. The stack now runs python-telegram-bot 22.1 with encrypted persistence, strict type checking, and automated CI. End users see fewer errors and tone-aware replies. Developers get a modern, maintainable codebase ready for future growth.

## SARAH Changelog

---

## [Unreleased]

### 1 · End-User Highlights

- **Smarter and faster replies**: topic detection, sentiment cues, improved caching.
- **More empathetic tone**: wording adapts to user mood in real time.
- **Persistent menu**: change language, switch modes, or get help without commands.
- **Quicker media**: `/image` and GIF replies use HTTP/2.
- **Fewer hiccups**: async backups and rate-limit rollback reduce “Try again later” errors.
- **Safer groups**: spoofed names blocked, stored data passes stricter static analysis.
- **Faster first response**: preload key packages to save about 15 %.
- **Reliable GIFs**: bad links are skipped or retried automatically.
- **Interactive menus v2**: multi-level inline keyboards for onboarding and admin tools.

---

### 2 · Developer Highlights

- **Built-in sentiment and theme engines** with background processing that avoids event-loop blocking.
- **Repo reorg**: flatter structure, absolute imports, clearer config and persistence layers.
- **PTB 22.1 features**: HTTP/2 client, permanent menu button, topic-aware messages.
- **Unified encrypted persistence** with automatic fallback when SQLite encryption is unavailable.
- **Improved app state**: dynamic adapter, clean mypy run on Python 3.12+.
- **Optimised LLM pipeline** with concurrency controls and safe rate-limit rollback.
- **Metrics batching**: in-memory accumulator flushes periodically and on shutdown.
- **Entity helpers**: underline, spoiler, mention, safe splitting, and concatenation utilities.
- **Task scheduler**: APScheduler wrapper with SQLite job store.
- **Pre-commit shield**: Ruff, Black, MyPy, Bandit chain; autofix locally, check-only in CI.
- **Granular typing**: per-package strictness, tests whitelisted, pydantic stubs enabled.
- **CI/CD hardening**: refined GitHub Actions, Python 3.12+, tuned cache.
- **Import map patch**: legacy import shim keeps backward compatibility.
- **Coverage roadmap**: targeting a lift from 62 % to 90 % on critical modules.

---

### 3 · Technical Log (condensed)

#### Added

- **Sentiment and theme analysis** with async processing and similarity scoring.
- **Metrics flush loop** with graceful shutdown hook.
- **Blueprint** for persistent reply keyboard and command menu button.
- **Rewritten config and lint setups** for consistency.
- **Markdown entity utilities** for safe text formatting.
- **HTTP/2 client wrapper** with proxy support.
- **Scheduler helper** with cron and interval registration.
- **Dynamic persistence adapter** with static typing.
- **Developer scripts and integration tests** for lifespan, webhook, limiter rollback, and GIF handling.
- **SQLite init script** that bootstraps encryption.

#### Changed

- **User input sanitation** now off-loads HTML cleaning to a background thread.
- **Response pipeline** combines theme and sentiment scoring with adaptive thresholds.
- **Thread safety** improved by moving shared locks to async variants.
- **Caching unified** on TTL caches with live reload.
- **Rate-limit guards** roll back on failure to free quotas.
- **CI workflows** target only supported Python versions and enforce final lint hook order.

#### Fixed

- Multiple warnings and errors eliminated across sanitisation, lint, typing, HTTP clients, cache resets, and workflow syntax.

#### Removed

- Legacy artefacts, obsolete utilities, and unused scaffolding.

---

### 4 · Potential Monetisation Pathways

_Exploratory, subject to change._

| Horizon    | Ideas                                                  |
| ---------- | ------------------------------------------------------ |
| Short-term | Telegram Stars, freemium limits, single-month premium  |
| Mid-term   | Credit packs, premium modes, paid media, group premium |
| Long-term  | Enterprise tier, automatic boosts, referrals, ad share |
