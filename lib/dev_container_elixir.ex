defmodule DevContainerElixir do
  @moduledoc """
  Mix tasks for managing Docker-based development containers in Elixir/Phoenix projects.

  ## Available Tasks

    * `mix dev_container.install` — generates `Dockerfile.dev`, `docker-compose.dev.yml`,
      and a helper shell script into your project

    * `mix dev_container.build` — builds the dev Docker image

    * `mix dev_container.start` — starts the dev container in the background

    * `mix dev_container.stop` — stops the running dev container

    * `mix dev_container.destroy` — removes the container and its volumes

    * `mix dev_container.status` — shows metadata from running dev containers

    * `mix dev_container.install_ralph` — downloads Ralph agent scripts into `scripts/ralph/`

  ## Quick Start

      mix dev_container.install
      mix dev_container.build
      mix dev_container.start

  Container and database names use `app_name.dirname` format
  (e.g., an app named `:my_app` in directory `my_app` gets container name `my_app.my_app`).
  """
end
