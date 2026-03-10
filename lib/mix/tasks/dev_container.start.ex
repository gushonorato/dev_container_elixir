defmodule Mix.Tasks.DevContainer.Start do
  @shortdoc "Starts a dev Docker container in background"
  @moduledoc """
  Starts a dev Docker container in background and prints
  the command to attach a shell.

      mix dev_container.start
  """

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    name = Mix.Tasks.DevContainer.Docker.default_name()

    Mix.shell().info("Container: #{name}")
    Mix.shell().info("Database:  #{name}")

    claude_container_dir = Path.join(System.user_home!(), ".claude_container")
    claude_dir = Path.join(claude_container_dir, ".claude")
    claude_json = Path.join(claude_container_dir, ".claude.json")

    File.mkdir_p!(claude_dir)
    unless File.exists?(claude_json), do: File.touch!(claude_json)

    Mix.shell().info("\nStarting container...")

    Mix.Tasks.DevContainer.Docker.docker_compose(["up", "-d", "--no-build"])

    Mix.shell().info("""
    \nContainer running. To open a shell:

        scripts/dev_container/dev-container-run          # bash
        scripts/dev_container/dev-container-run claude   # claude code
    """)
  end
end
