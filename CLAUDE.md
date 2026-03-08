# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a multi-repo Jenkins CI/CD test environment demonstrating a **multibranch orchestrator pipeline pattern** for mobile (iOS/Android) apps with GitHub commit status reporting. The core problem it solves: allowing individual failed pipeline stages to be re-run without restarting the entire pipeline.

## Repository Layout

This directory contains four interconnected repositories:

| Repo | Purpose | GitHub |
|------|---------|--------|
| `jenkins-setup/` | Jenkins infrastructure (Docker, CASC, Job DSL) | [gosuwachu/jenkins-setup](https://github.com/gosuwachu/jenkins-setup) |
| `mobile-app/` | App repo with thin trigger stub Jenkinsfile + platform dirs | [gosuwachu/mobile-app](https://github.com/gosuwachu/mobile-app) |
| `mobile-app-ci/` | CI step definitions: child Jenkinsfiles, Python CLI, shared library | [gosuwachu/mobile-app-ci](https://github.com/gosuwachu/mobile-app-ci) |
| `ci-dashboard/` | Next.js CI monitoring dashboard | [gosuwachu/ci-dashboard](https://github.com/gosuwachu/ci-dashboard) |

Each repo has its own `CLAUDE.md` with repo-specific details. Read those before making changes.

## Architecture

```
PR/branch push
  → Multibranch discovers in mobile-app
  → ci/trigger.Jenkinsfile (thin stub, loads shared library from CI repo)
  → vars/triggerPipeline.groovy orchestrator:
      1. Collaborator check (blocks unauthorized PRs)
      2. Platform detection (diffs ios/ and android/ dirs)
      3. Publishes "skipped" statuses for unchanged platforms
      4. Triggers omnibus job per step (parallel):
         Build & Quality: build, unit-tests, linter (per platform)
         Deploy: deploy (per platform)
  → Each child Jenkinsfile (in CI repo) calls ./ci-cli <platform> <step>
  → CLI checks out app at pinned COMMIT_SHA, runs build script, publishes commit status
```

**Key design decisions:**
- Child jobs publish their own GitHub commit statuses (not the orchestrator) — each is individually re-triggerable
- Uses commit statuses API (not Checks API) — simpler but no GitHub "Re-run" button
- Omnibus job pattern: single parameterized job runs any Jenkinsfile via `JENKINSFILE` parameter
- Shared library for orchestrator: provides visualization of checks in Jenkins UI

## Common Commands

### Jenkins Infrastructure (jenkins-setup/)
```bash
./scripts/start.sh                    # Build + start Jenkins (localhost:8080, admin/admin)
docker-compose down                   # Stop
docker-compose down -v                # Full reset (clear all data)
./scripts/jenkins-api.sh build <path> # Trigger a build
./scripts/jenkins-api.sh log <path>   # View console log
./scripts/jenkins-api.sh status <path> # Get job status
```

### CI Dashboard (ci-dashboard/)
```bash
npm run dev                           # Start dev server (localhost:3000)
npm run build                         # Production build (use this to verify, no need to rm .next first)
```

### CI Repo (mobile-app-ci/)
```bash
./run-tests -v                        # All checks: mypy, pylint, vulture, pytest
PYTHONPATH=src .venv/bin/pytest -v     # Just pytest
PYTHONPATH=src .venv/bin/pytest tests/test_changes.py -v  # Single test file
./lint-jenkinsfiles                   # Lint Groovy Jenkinsfiles
GH_TOKEN=<token> ./ci-cli ios build --commit-sha <sha> --build-url <url>  # Run CLI locally
```

## Credentials

| ID | Type | Used By | Purpose |
|----|------|---------|---------|
| `github-pat` | Username/Password | Multibranch SCM, omnibus | Checkout (avoids auto-publishing checks) |
| `github-app` | GitHub App | Child Jenkinsfiles | Commit status API, collaborator checks |

## Workflow After Making Changes

1. Commit in all affected repos
2. Push companion repos (app, CI) — Jenkins pulls from GitHub
3. For Job DSL changes: `docker cp` + run seed-job (or rebuild Docker if Dockerfile/plugins/CASC changed)
4. Test: `./scripts/jenkins-api.sh build mobile-app/trigger/main CI_BRANCH=main`

## Key Files

| File | What it does |
|------|-------------|
| `jenkins-setup/jobs/pipeline.groovy` | Job DSL defining all Jenkins jobs |
| `jenkins-setup/casc/jenkins.yaml` | Jenkins Configuration as Code |
| `mobile-app/ci/trigger.Jenkinsfile` | Thin stub loading shared library |
| `mobile-app-ci/vars/triggerPipeline.groovy` | Orchestrator logic (shared library) |
| `mobile-app-ci/src/company/ci/steps.py` | CI step definitions (STEPS dict) |
| `mobile-app-ci/src/company/ci/cli.py` | CLI argument parsing |
| `mobile-app-ci/src/company/ci/github.py` | GitHub API (statuses, collaborator checks) |

## Adding a New CI Step

1. Add `StepConfig` entry to `STEPS` and a `run_<step>` function in `mobile-app-ci/src/company/ci/steps.py`
2. Add the function to `STEP_FUNCTIONS` in `cli.py` and update the dispatch logic
3. Create build script in `mobile-app/{platform}/{platform}_build/{script}.sh`
4. Create Jenkinsfile in `mobile-app-ci/ci/<platform>/<platform>-<step>.Jenkinsfile`
5. Add context to `IOS_CONTEXTS`/`ANDROID_CONTEXTS` in `mobile-app-ci/vars/triggerPipeline.groovy`
