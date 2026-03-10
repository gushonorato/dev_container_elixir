defmodule Mix.Tasks.DevContainer.Database do
  @shortdoc "Prints the dev container name"
  @moduledoc """
  Prints the dev container name (derived from the app name).

      mix dev_container.database

  Useful for scripts that need the container/database name.
  """

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    Mix.shell().info(Mix.Tasks.DevContainer.Docker.default_name())
  end
end
