defmodule Mix.Tasks.DevContainer.Docker do
  @moduledoc false

  defp project_root do
    Mix.Project.project_file() |> Path.dirname()
  end

  def compose_file do
    Path.join(project_root(), "docker-compose.dev.yml")
  end

  def default_name do
    "#{Mix.Project.config()[:app]}_dev"
  end

  def env(name) do
    [
      {"APP_NAME", "#{Mix.Project.config()[:app]}"},
      {"APP_SRC_PATH", project_root()},
      {"CONTAINER_NAME", name},
      {"DATABASE", name}
    ]
  end

  def docker_compose(args, opts \\ []) do
    name = Keyword.get(opts, :name, default_name())
    env = Keyword.get(opts, :env, env(name))

    System.cmd(
      "docker",
      ["compose", "-p", name, "-f", compose_file()] ++ args,
      env: env,
      into: IO.stream(:stdio, :line)
    )
  end
end
