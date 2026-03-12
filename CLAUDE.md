# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Elixir Mix task library (`dev_container_elixir`) that provides `mix dev_container.*` commands for managing Docker-based development containers in Elixir/Phoenix projects. It is a library dependency — not a running OTP application.

## Build & Development Commands

```bash
mix deps.get          # Install dependencies
mix test              # Run all tests
mix test test/path_test.exs       # Run a single test file
mix test test/path_test.exs:42    # Run a specific test by line number
mix format            # Format code
mix format --check-formatted      # Check formatting without changes
```

## Architecture

All code lives under `lib/mix/tasks/` as Mix tasks following the `Mix.Tasks.DevContainer.*` namespace.

**Core module:** `Mix.Tasks.DevContainer.Docker` (`lib/mix/tasks/dev_container/docker.ex`) — shared helper that centralizes all `docker compose` invocations. Every task that interacts with Docker delegates through `docker_compose/2`.

**Task modules** (each in `lib/mix/tasks/dev_container.*.ex`):
- `Install` — generates `Dockerfile.dev`, `docker-compose.dev.yml`, and a shell script into the consuming project using embedded string templates and `Mix.Generator`
- `Build`, `Start`, `Stop`, `Destroy` — thin wrappers around the shared `Docker` module
**Key conventions:**
- Container and database names use `app_name.dirname` format (e.g., `my_app.my_app` for the main project, `my_app.feature_branch` for a worktree)
- The generated Dockerfile includes Claude Code CLI, Node.js, and Playwright pre-installed
- The `Install` task interpolates app name, container name, and database directly into the generated `docker-compose.dev.yml` at install time — no environment variables needed

**Only dependency:** `ex_doc ~> 0.35` (dev only, for documentation generation).
