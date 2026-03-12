defmodule Mix.Tasks.DevContainer.Docker do
  @moduledoc false

  defp project_root do
    Mix.Project.project_file() |> Path.dirname()
  end

  def compose_file do
    Path.join(project_root(), "docker-compose.dev.yml")
  end

  def container_name do
    app = Mix.Project.config()[:app]
    dir = project_root() |> Path.basename()
    "#{app}.#{dir}"
  end

  def docker_compose(args, opts \\ []) do
    name = Keyword.get(opts, :name, container_name())

    System.cmd(
      "docker",
      ["compose", "-p", name, "-f", compose_file()] ++ args,
      into: IO.stream(:stdio, :line)
    )
  end
end
