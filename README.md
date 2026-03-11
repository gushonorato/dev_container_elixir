# DevContainerElixir

Mix tasks for managing Docker-based development containers in Elixir and Phoenix projects.

Generates a `Dockerfile.dev`, `docker-compose.dev.yml`, and helper scripts, then provides commands to build, start, stop, and inspect your dev container — all from `mix`.

## Installation

Add `dev_container_elixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dev_container_elixir, "~> 0.1.0", only: :dev, runtime: false}
  ]
end
```

Then run:

```bash
mix deps.get
```

## Quick Start

```bash
# 1. Generate dev container files in your project
mix dev_container.install

# 2. Build the Docker image
mix dev_container.build

# 3. Start the container
mix dev_container.start

# 4. Run commands inside the container
scripts/dev_container/dev-container-run iex -S mix phx.server
```

## Available Tasks

| Task | Description |
|------|-------------|
| `mix dev_container.install` | Generates `Dockerfile.dev`, `docker-compose.dev.yml`, and a shell script |
| `mix dev_container.build` | Builds the dev Docker image |
| `mix dev_container.start` | Starts the dev container |
| `mix dev_container.stop` | Stops the dev container |
| `mix dev_container.destroy` | Removes the dev container and its volumes |
| `mix dev_container.status` | Shows metadata from running dev containers |
| `mix dev_container.database` | Prints the convention-based container/database name |

## Conventions

- Container and database names are derived from your app name with a `_dev` suffix (e.g., `my_app_dev`)
- The generated Dockerfile includes Node.js, Playwright, and Claude Code CLI pre-installed
- Docker containers are tagged with labels for service discovery by the `status` task

## License

MIT — see [LICENSE](LICENSE).
