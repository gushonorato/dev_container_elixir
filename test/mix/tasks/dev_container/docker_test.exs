defmodule Mix.Tasks.DevContainer.DockerTest do
  use ExUnit.Case

  alias Mix.Tasks.DevContainer.Docker

  describe "compose_file/0" do
    test "returns path ending with docker-compose.dev.yml" do
      assert Docker.compose_file() |> Path.basename() == "docker-compose.dev.yml"
    end

    test "returns an absolute path" do
      assert Docker.compose_file() |> Path.type() == :absolute
    end
  end

  describe "container_name/0" do
    test "returns app_name_dirname format" do
      dir = Mix.Project.project_file() |> Path.dirname() |> Path.basename()
      assert Docker.container_name() == "dev_container_elixir_#{dir}"
    end
  end

end
