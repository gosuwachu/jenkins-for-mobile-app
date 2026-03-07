# Jenkins CI/CD Test Environment

A multi-repo Jenkins environment demonstrating a **multibranch orchestrator pipeline pattern** for mobile (iOS/Android) apps with GitHub commit status reporting.

The core problem it solves: allowing individual failed pipeline stages to be re-run without restarting the entire pipeline.

## Quick Start

```bash
./setup.sh
```

This clones all repositories, builds the Jenkins Docker image, and starts Jenkins.

Then:
1. Open Jenkins at http://localhost:8080 (admin / admin)
2. Open a PR against the [app repo](https://github.com/gosuwachu/jenkinsfiles-test-app/compare) to trigger the pipeline

## Repositories

| Directory | Purpose | GitHub |
|-----------|---------|--------|
| `jenkinsfiles-test/` | Jenkins infrastructure (Docker, CASC, Job DSL) | [gosuwachu/jenkinsfiles-test](https://github.com/gosuwachu/jenkinsfiles-test) |
| `jenkinsfiles-test-app/` | App repo with thin trigger Jenkinsfile + platform dirs | [gosuwachu/jenkinsfiles-test-app](https://github.com/gosuwachu/jenkinsfiles-test-app) |
| `jenkinsfiles-test-app-ci/` | CI definitions: child Jenkinsfiles, Python CLI, shared library | [gosuwachu/jenkinsfiles-test-app-ci](https://github.com/gosuwachu/jenkinsfiles-test-app-ci) |

## How It Works

```
PR/branch push
  -> Multibranch discovers branch in jenkinsfiles-test-app
  -> ci/trigger.Jenkinsfile (thin stub, loads shared library from CI repo)
  -> vars/triggerPipeline.groovy orchestrator:
      1. Collaborator check (blocks unauthorized PRs)
      2. Platform detection (diffs ios/ and android/ dirs)
      3. Publishes "skipped" statuses for unchanged platforms
      4. Triggers omnibus job per step (parallel):
         Build & Quality: build, unit-tests, linter (per platform)
         Deploy: deploy (per platform)
  -> Each child Jenkinsfile calls ./ci-cli <platform> <step>
  -> CLI checks out app at pinned COMMIT_SHA, publishes its own commit status
```

**Key design decisions:**
- Child jobs publish their own GitHub commit statuses (not the orchestrator) -- each is individually re-triggerable
- Uses commit statuses API (not Checks API) -- simpler but no GitHub "Re-run" button
- Omnibus job pattern: single parameterized job runs any Jenkinsfile via `JENKINSFILE` parameter

## Common Commands

```bash
# Start / stop Jenkins
./jenkinsfiles-test/scripts/start.sh
docker-compose -f jenkinsfiles-test/docker-compose.yml down

# Full reset (clear all data)
docker-compose -f jenkinsfiles-test/docker-compose.yml down -v

# Trigger a build
./jenkinsfiles-test/scripts/jenkins-api.sh build pipeline/job/trigger/job/main CI_BRANCH=main

# View console log / status
./jenkinsfiles-test/scripts/jenkins-api.sh log pipeline/job/trigger/job/main
./jenkinsfiles-test/scripts/jenkins-api.sh status pipeline/job/trigger/job/main

# Run CI repo tests
cd jenkinsfiles-test-app-ci && ./run-tests -v
```

## Prerequisites

- Docker
- Git (with SSH access to GitHub)
