defmodule Mix.Tasks.DevContainer.Install do
  @shortdoc "Installs dev container files into the project"
  @moduledoc """
  Generates dev container files in the current project:

    * `Dockerfile.dev` — development Docker image
    * `docker-compose.dev.yml` — Docker Compose config
    * `dev-run` — shell script to exec into container

      mix dev_container.install
  """

  use Mix.Task
  import Mix.Generator

  @impl Mix.Task
  def run(_args) do
    root = Mix.Project.project_file() |> Path.dirname()

    create_file(Path.join(root, "Dockerfile.dev"), dockerfile_template())
    create_file(Path.join(root, "docker-compose.dev.yml"), compose_template())

    script_path = Path.join(root, "dev-run")
    create_file(script_path, run_script_template())
    File.chmod!(script_path, 0o755)

    Mix.shell().info("""
    \nDev container files installed. Next steps:

        mix dev_container.build    # Build the Docker image
        mix dev_container.start    # Start the container
    """)
  end

  defp dockerfile_template do
    ~S"""
    ARG ELIXIR_VERSION=1.19.5
    ARG OTP_VERSION=28.2
    ARG DEBIAN_VERSION=bookworm-20260202-slim

    FROM hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}

    # System deps: build tools, runtime libs, inotify for live reload
    RUN apt-get update -y && \
        apt-get install -y \
          build-essential git curl sudo vim \
          libstdc++6 openssl libncurses5 locales ca-certificates \
          inotify-tools \
        && curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
        && apt-get install -y nodejs \
        && apt-get clean && rm -f /var/lib/apt/lists/*_*

    # Locale
    RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
    ENV LANG=en_US.UTF-8
    ENV LANGUAGE=en_US:en
    ENV LC_ALL=en_US.UTF-8

    # Create non-root user with matching UID/GID for bind-mount compatibility
    ARG USER_UID=1000
    ARG USER_GID=1000
    RUN groupadd --gid $USER_GID dev && \
        useradd --uid $USER_UID --gid $USER_GID --create-home --shell /bin/bash dev && \
        echo "dev ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dev

    # Playwright system deps (needs root)
    RUN npx playwright install-deps chromium

    # Switch to non-root user for remaining setup
    USER dev

    # Elixir tools
    RUN mix local.hex --force && mix local.rebar --force

    # Playwright browser (as non-root)
    RUN npx playwright install chromium

    # Claude Code CLI
    RUN curl -fsSL https://claude.ai/install.sh | bash
    ENV PATH="/home/dev/.local/bin:${PATH}"

    # npm global prefix for non-root user
    RUN mkdir -p /home/dev/.npm-global && npm config set prefix /home/dev/.npm-global
    ENV PATH="/home/dev/.npm-global/bin:${PATH}"

    # Git safe directory for bind-mounted volume
    RUN git config --global --add safe.directory /app

    WORKDIR /app

    CMD ["/bin/bash"]
    """
    |> String.trim_leading()
  end

  defp compose_template do
    ~S"""
    services:
      dev:
        image: ${APP_NAME}-dev
        container_name: ${CONTAINER_NAME:-${APP_NAME}-dev}
        build:
          context: .
          dockerfile: Dockerfile.dev
        stdin_open: true
        tty: true
        volumes:
          - "${APP_SRC_PATH:-.}:/app"
          - "${HOME}/.claude_container/.claude.json:/home/dev/.claude.json"
          - "${HOME}/.claude_container/.claude:/home/dev/.claude"
        environment:
          - DATABASE_HOST=host.docker.internal
          - DATABASE=${DATABASE:-${APP_NAME}_dev}
        extra_hosts:
          - "host.docker.internal:host-gateway"
        labels:
          dev.app_name: "${APP_NAME}"
          dev.container_name: "${CONTAINER_NAME:-${APP_NAME}-dev}"
          dev.database: "${DATABASE:-${APP_NAME}_dev}"
          dev.src_path: "${APP_SRC_PATH:-.}"
        command: sleep infinity
    """
    |> String.trim_leading()
  end

  defp run_script_template do
    ~S"""
    #!/usr/bin/env bash
    set -euo pipefail

    PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
    APP_NAME="$(grep -m1 'app:' "$PROJECT_ROOT/mix.exs" | sed 's/.*app: :\([a-z_]*\).*/\1/')"
    NAME="${APP_NAME}_dev"
    COMPOSE_FILE="${PROJECT_ROOT}/docker-compose.dev.yml"

    if [ $# -eq 0 ]; then
      CMD=(bash)
    else
      CMD=("$@")
    fi

    export APP_NAME
    export CONTAINER_NAME="$NAME"

    if ! docker compose -p "$NAME" -f "$COMPOSE_FILE" exec -T dev true 2>/dev/null; then
      echo ""
      echo "Container nao esta rodando! Para iniciar:"
      echo ""
      echo "  1. mix dev_container.build     # Construir a imagem (primeira vez)"
      echo "  2. mix dev_container.start     # Subir o container"
      echo ""
      echo "Depois tente novamente:"
      echo ""
      echo "  ./dev-run                          # bash"
      echo "  ./dev-run claude                   # claude code"
      echo "  ./dev-run iex -S mix phx.server   # phoenix com iex"
      echo ""
      exit 1
    fi

    exec docker compose -p "$NAME" -f "$COMPOSE_FILE" exec dev "${CMD[@]}"
    """
    |> String.trim_leading()
  end
end
