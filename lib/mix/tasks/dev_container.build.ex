defmodule Mix.Tasks.DevContainer.Build do
  @shortdoc "Builds the dev Docker image"
  @moduledoc """
  Builds the dev Docker image.

      mix dev_container.build
  """

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    Mix.shell().info("Building dev image...")
    Mix.Tasks.DevContainer.Docker.docker_compose(["build"])
  end
end
