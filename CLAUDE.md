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
- `Status` — queries running containers via Docker labels and parses metadata with `Jason`
- `Database` — prints the convention-based container/database name

**Key conventions:**
- Container and database names are derived from `Mix.Project.config()[:app]` with `_dev` suffix
- Docker containers are tagged with labels (`dev.app_name`, `dev.database`, etc.) for service discovery by the `status` task
- The generated Dockerfile includes Claude Code CLI, Node.js, and Playwright pre-installed
- Environment variables (`APP_NAME`, `APP_SRC_PATH`, `CONTAINER_NAME`, `DATABASE`) are passed to Docker Compose from Mix project config

**Only dependency:** `jason ~> 1.4` (used in the status task for JSON parsing).
