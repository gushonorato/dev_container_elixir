defmodule Mix.Tasks.DevContainer.Destroy do
  @shortdoc "Removes dev Docker containers, images, and volumes"
  @moduledoc """
  Removes dev Docker containers, images, and volumes.

      mix dev_container.destroy
  """

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    name = Mix.Tasks.DevContainer.Docker.default_name()

    Mix.shell().info("Destroying #{name}...")
    Mix.Tasks.DevContainer.Docker.docker_compose(["down", "--rmi", "all", "--volumes"])
  end
end
