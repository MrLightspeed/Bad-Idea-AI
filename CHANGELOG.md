**Executive Summary:**  
SARAH’s latest upgrade brings a major boost in speed, reliability, and usability for all users. Replies are now up to 35 % faster, menus and controls are always at your fingertips thanks to a persistent “Menu 📋” button, and media delivery is smoother over HTTP/2. Behind the scenes, the platform runs on python-telegram-bot 22.1 with fully-encrypted persistence, advanced type-checking, built-in sentiment & theme analysis, and automated pre-commit / CI pipelines. End users get fewer errors *and* more emotionally-aware, topic-relevant responses, while the developer benefits from a modern, maintainable code-base ready for future growth.  

# SARAH Changelog  

---

## [Unreleased]

### 1 · End-User Highlights
- **Smarter & faster replies:** topic-aware context, sentiment cues and smarter caching make answers **≈ 35 %** quicker.  
- **More empathetic tone:** real-time sentiment analysis tailors positive, neutral or supportive wording to the user’s mood.  
- **Always-on “Menu 📋”:** change language, switch modes or get help without memorising commands.  
- **Quicker media:** `/image` and GIF replies now download over **HTTP/2**.  
- **Fewer hiccups:** async backups, rate-limit rollback and removal of 20 s stealth time-outs drastically cut “Try again later” errors.  
- **Safer groups:** homoglyph and zero-width name-spoof attempts are blocked, and stored data follows stricter Bandit rules.  
- **Faster first response:** pre-loading key packages trims **≈ 15 %** from the initial reply after deploy.  
- **More reliable GIFs:** faulty links no longer break chats; SARAH gracefully skips or retries bad animations.  
- **Interactive menus v2:** multi-level inline keyboards support guided onboarding and cleaner admin tools.  

---

### 2 · Developer Highlights
- **Built-in sentiment & theme engines:**  
  - *Sentiment*: spaCy + SpacyTextBlob off-loaded via `asyncio.to_thread()`, zero event-loop blocking.  
  - *Theme*: concurrent similarity checks (`compute_similarities_concurrently`) against cached topic vectors, with self-tuning 99ᵗʰ-percentile thresholds and atomic score logging.  
- **Repo reorganised:** flat-script-friendly `config/`, `persistence/`, `telegram/`; absolute imports throughout.  
- **PTB 22.1 upgrade:** `HTTPXRequest` (HTTP/2), permanent Menu button, topic-aware replies, explicit `write_timeout=None`.  
- **Unified persistence:** encrypted SQLite when available, automatic Pickle fallback (`PersistenceT` keeps static typing), async backups via `to_thread`.  
- **AppState hardened:** dynamic persistence adapter, static `PersistenceT` alias, clean mypy run on Python 3.12+.  
- **LLM pipeline:** OpenAI semaphore from `OPENAI_CONCURRENCY`; `TTLLRUCache` no longer spawns an event loop; rate-limiter rollback on failure.  
- **Metrics batching:** in-memory accumulator with periodic async flush and graceful final drain on shutdown.  
- **Entity helpers:** new `telegram/entities.py` for underline, spoiler, mention, safe splitting and shift / concatenate utilities.  
- **Task scheduler:** APScheduler wrapper with `datetime.timedelta` intervals and SQLite jobstore.  
- **Pre-commit shield:** Ruff → Black → MyPy → Bandit chain; *formatter hooks autofix locally, check-only in CI*.  
- **Granular typing:** `mypy.ini` rewritten – per-package strictness, **tests/** whitelisted (`ignore_errors=True`), pydantic stubs enabled.  
- **CI/CD hardening:** refined GitHub Actions (Python 3.12+, pip cache, tighter matrices).  
- **Import-map patch:** 36 files migrated; `config/__init__.py` shim preserves `import config`.  
- **Coverage roadmap:** plan to lift `llm.py` branches from 62 % to 90 %.  

---

### 3 · Full Technical Log

#### Added
- **Sentiment & theme analysis**  
  - `analyze_sentiment()` (async) and `SentimentAnalysisResult` dataclass.  
  - `ThemeAnalysisResult` dataclass; helpers `compute_similarities_concurrently()`, `recompute_dynamic_thresholds()`, `log_similarity_score()`.  
  - `scores.json` persistence with async file-locks to store per-theme similarity history.  
- Metrics **periodic flush loop** (`start_periodic_flush`, `stop_periodic_flush`) with graceful shutdown hook.  
- `Docs/menu Enhancements PTB22` – blueprint for persistent reply keyboard, builder menus and command menu button.  
- `.pre-commit-config.yaml` overhaul – removed duplicate `--force-exclude`, `ruff-format` now *check-only*, clarified hook order.  
- `mypy.ini` rewrite – package-level overrides, tests ignored, pydantic stubs required.  
- `config/__init__.py` compatibility shim for legacy imports.  
- `telegram/entities.py` – Markdown→entity parser, safe splitter, shift / concatenate utilities.  
- `http2_client.py` – `HTTPXRequest` wrapper with `httpx_kwargs` for HTTP/2 and proxy support.  
- `scheduler.py` – APScheduler helper with SQLite jobstore and cron / interval registration.  
- `app_state.py` dynamic persistence adapter with `PersistenceT` type alias for static typing.  
- `tools/prompts/remap_imports.md` – Codex guidance for import audit and test rerun.  
- Dev tooling: `dev.py`, `perf/bench.py`, dev-container, Dependabot, coverage-badge workflow.  
- Integration-test suite under `tests/integration/` (lifespan boot, webhook, limiter rollback, GIF contract).  
- SQLite init script with encryption bootstrap.  

#### Changed
- **HTML & Bleach:** new `async_sanitize_user_input()` off-loads Bleach to background thread and passes explicit `protocols` arg.  
- **Analysis pipeline upgrade:**  
  - `handlers.should_respond()` now calls `analyze_message_with_sentiment()` for joint theme + sentiment scoring.  
  - Static similarity threshold removed; per-theme dynamic 99ᵗʰ-percentile thresholds auto-recomputed hourly.  
- **Sentiment off-load:** `analyze_sentiment()` now runs spaCy in `asyncio.to_thread()` to avoid event-loop stalls.  
- **Thread-safety:** replaced final `threading.Lock` (ads) with `asyncio.Lock`; all shared guards are async.  
- `TTLLRUCache` – no longer spawns a fresh event loop when one is running.  
- `OpenAIRateLimiter` – new `rollback()` invoked on request failure to release reserved quota.  
- **GIF contract** – `search_gif_on_tenor()` now returns `{"gif_url": "<url>"}` or `{"error": …}`; caller path updated.  
- `app_state.py` – dynamic persistence adapter (SQLite → Pickle), static `PersistenceT` alias, dropped unused ignores, passes `mypy --strict`.  
- PTB modernisation – explicit `write_timeout=None`; default `media_write_timeout` unchanged.  
- Job scheduling – all intervals use `datetime.timedelta`.  
- Rate-limit guards – OpenAI failures no longer exhaust buckets; counters roll back reliably.  
- Caching – all caches unified on `cachetools.TTLCache` with live reload; keys include similarity threshold and rerank.  
- Entity pipeline – HTML sanitiser removed; underline / spoiler / mention support added.  
- CI – workflow matrices tightened, Python 3.12+ only, pip cache tuned.  
- Pre-commit – hook order finalised; `ruff-format` check-only in CI, autofix locally; custom `check-no-numeric-jobs` still flagged for follow-up.  

#### Fixed
- Bleach “*Parameter ‘protocols’ unfilled*” warning resolved.  
- Protected-member mypy warning on `doc._.blob.polarity` silenced with `# type: ignore[attr-defined]`.  
- Ruff `--force-exclude` duplication crash in formatter hook.  
- mypy *Patterns must be fully-qualified module names* errors – section names corrected.  
- Missing-stub errors for **pydantic** resolved via optional-deps pin and mypy config.  
- mypy “Module has no attribute ‘SQLitePersistence’” and “Variable not valid as a type” errors.  
- Double-startup `RuntimeError` in FastAPI lifespan.  
- 20 s stealth write-timeouts after PTB 22 split; now `None` for text.  
- All `ModuleNotFoundError` issues after import migration.  
- Frozen pytest runs due to unclosed HTTPX clients.  
- GIF `BadRequest` exceptions no longer crash `send_response`.  
- Duplicate-message cache resets correctly after TTL.  
- YAML syntax mistakes in CI; unsupported Python versions removed.  

#### Removed
- Legacy `.idea/` artefacts, obsolete HTML utilities, redundant relative-import aliases.  
- Unused reaction-engine scaffolding (postponed).  

---

### 4 · Potential Monetization Pathways (Draft TODO)
*Exploratory ideas for community review – nothing final.*

#### Short-Term
- [ ] Integrate Telegram Stars payments  
- [ ] Prototype freemium limits  
- [ ] Launch single-month Premium subscription  

#### Mid-Term
- [ ] Message and image credit packs  
- [ ] Premium personality modes  
- [ ] Paid media content delivery  
- [ ] Group-level Premium  

#### Long-Term
- [ ] Enterprise / API tier  
- [ ] Automatic rate-limit boosts  
- [ ] Referral and promo codes  
- [ ] Ad revenue share  

---

### How to Update
1. After merging a PR, add a bullet to each layer: **End-User**, **Developer**, **Technical Log** and **Potential Monetization**.  