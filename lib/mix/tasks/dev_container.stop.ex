defmodule Mix.Tasks.DevContainer.Stop do
  @shortdoc "Stops running dev Docker containers"
  @moduledoc """
  Stops dev Docker containers.

      mix dev_container.stop
  """

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    name = Mix.Tasks.DevContainer.Docker.default_name()

    Mix.shell().info("Stopping #{name}...")
    Mix.Tasks.DevContainer.Docker.docker_compose(["stop"])
  end
end
